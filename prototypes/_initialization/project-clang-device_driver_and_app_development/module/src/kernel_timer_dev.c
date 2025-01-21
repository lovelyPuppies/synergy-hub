/* =========================
 *  Includes and Definitions
 * ========================= */
#include "uapi/ledkey_ioctl.h"
#include <linux/errno.h>
#include <linux/fcntl.h>
#include <linux/fs.h>
#include <linux/gpio.h>
#include <linux/init.h>
#include <linux/interrupt.h>
#include <linux/irq.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/mutex.h>
#include <linux/poll.h>
#include <linux/timer.h>
#include <linux/types.h>
#include <linux/wait.h>

#define LEDKEY_DEV_NAME  "ledKey"
#define LEDKEY_DEV_MAJOR 230
#define GPIO_COUNT       8
#define OFF              0
#define ON               1

/* =========================
 *  Global Variables
 * ========================= */
static int gpioLed[GPIO_COUNT] = {518, 519, 520, 521, 522, 523, 524, 525};
static int gpioKey[GPIO_COUNT] = {528, 529, 530, 531, 532, 533, 534, 535};
static int openFlag = 0;
static int timerVal = 255;
module_param(timerVal, int, 0);
static int ledVal = 0;
module_param(ledVal, int, 0);
static struct timer_list timerLed;
static DEFINE_MUTEX(keyMutex);
static DECLARE_WAIT_QUEUE_HEAD(waitQueueRead);

/* =========================
 *  Structures
 * ========================= */
typedef struct {
  int keyNum;
  int irqKey[GPIO_COUNT];
} keyDataStruct;

/* =========================
 *  Function Prototypes
 * ========================= */
static int gpioLedInit(void);
static void gpioLedSet(long val);
static void gpioLedFree(void);
static int gpioKeyInit(void);
static void gpioKeyFree(void);
static int irqKeyInit(keyDataStruct *pkeyData);
static void irqKeyFree(keyDataStruct *pKeyData);
static void kernel_timer_func(struct timer_list *t);
static void kernel_timer_registertimer(unsigned long timeover);
irqreturn_t keyIsr(int irq, void *data);
static int ledkey_open(struct inode *inode, struct file *filp);
static ssize_t ledkey_read(struct file *filp, char *buf, size_t count,
                           loff_t *f_pos);
static ssize_t ledkey_write(struct file *filp, const char *buf, size_t count,
                            loff_t *f_pos);
static __poll_t ledkey_poll(struct file *filp, struct poll_table_struct *wait);
static int ledkey_release(struct inode *inode, struct file *filp);
static long timer_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
static int kernel_timer_init(void);
static void kernel_timer_exit(void);

/* =========================
 *  Timer Functions
 * ========================= */
static void kernel_timer_registertimer(unsigned long timeover) {
  // 🕥
  timerLed.expires = get_jiffies_64() + timeover;
  timer_setup(&timerLed, kernel_timer_func, 0);
  add_timer(&timerLed);
}

static void kernel_timer_func(struct timer_list *t) {
  printk(KERN_DEBUG "ledVal : %#04x\n", (unsigned int)(ledVal));
  gpioLedSet(ledVal);
  ledVal = ~ledVal & 0xff;
  mod_timer(t, get_jiffies_64() + timerVal);
}

/* =========================
 *  GPIO Functions
 * ========================= */
static int gpioLedInit(void) {
  int i, ret;
  char gpioName[10];

  for (i = 0; i < GPIO_COUNT; i++) {
    sprintf(gpioName, "led%d", i);
    ret = gpio_request(gpioLed[i], gpioName);
    if (ret < 0)
      printk(KERN_DEBUG "Failed request gpio%d error\n", gpioLed[i]);
    return ret;

    ret = gpio_direction_output(gpioLed[i], OFF);
    if (ret < 0)
      printk(KERN_DEBUG "Failed directon_output gpio%d error\n", gpioLed[i]);
    return ret;
  }
  return 0;
}

static void gpioLedSet(long val) {
  for (int i = 0; i < GPIO_COUNT; i++) {
    gpio_set_value(gpioLed[i], (val & (0x01 << i)));
  }
}

static void gpioLedFree(void) {
  for (int i = 0; i < GPIO_COUNT; i++) {
    gpio_free(gpioLed[i]);
  }
}

static int gpioKeyInit(void) {
  int i, ret;
  char gpioName[10];

  for (i = 0; i < GPIO_COUNT; i++) {
    sprintf(gpioName, "key%d", i);
    ret = gpio_request(gpioKey[i], gpioName);
    if (ret < 0)
      printk(KERN_DEBUG "Failed Request gpio%d error\n", gpioKey[i]);
    return ret;

    ret = gpio_direction_input(gpioKey[i]);
    if (ret < 0)
      printk(KERN_DEBUG "Failed direction_output gpio%d error\n", gpioKey[i]);
    return ret;
  }
  return 0;
}

static void gpioKeyFree(void) {
  for (int i = 0; i < GPIO_COUNT; i++) {
    gpio_free(gpioKey[i]);
  }
}

static int irqKeyInit(keyDataStruct *pKeyData) {
  for (int i = 0; i < GPIO_COUNT; i++) {
    // 🚣 Converts a GPIO pin to its corresponding IRQ number.
    pKeyData->irqKey[i] = gpio_to_irq(gpioKey[i]);
    if (pKeyData->irqKey[i] < 0) {
      printk(KERN_DEBUG "Failed gpio_to_irq() gpio%d error\n", gpioKey[i]);
      return pKeyData->irqKey[i];
    }
    printk(KERN_DEBUG "gpio_to_irq() gpio%d (irq%d) \n", gpioKey[i],
           pKeyData->irqKey[i]);
  }
  return 0;
}

static void irqKeyFree(keyDataStruct *pKeyData) {
  for (int i = 0; i < GPIO_COUNT; i++) {
    free_irq(pKeyData->irqKey[i], pKeyData);
  }
}

// 🚣 Interrupt Service Routine (ISR) that handles GPIO key presses.
irqreturn_t keyIsr(int irq, void *data) {
  int i;
  keyDataStruct *pKeyData = (keyDataStruct *)data;
  for (i = 0; i < GPIO_COUNT; i++) {
    if (irq == pKeyData->irqKey[i]) {
      if (mutex_trylock(&keyMutex) != 0) {
        pKeyData->keyNum = i + 1;
        mutex_unlock(&keyMutex);
        break;
      }
    }
  }
  printk(KERN_DEBUG "keyIsr() irq : %d, keyNum : %d\n", irq, pKeyData->keyNum);

  wake_up_interruptible(&waitQueueRead);
  return IRQ_HANDLED;
}

/* =========================
 *  File Operations
 * ========================= */
static int ledkey_open(struct inode *inode, struct file *filp) {

  printk(KERN_DEBUG "call open -> major.minor: %d.%d\n", MAJOR(inode->i_rdev),
         MINOR(inode->i_rdev));
  int result = 0;
  keyDataStruct *pKeyData;
  char *irqName[GPIO_COUNT] = {
      "irqKey0", "irqKey1", "irqKey2", "irqKey3",
      "irqKey4", "irqKey5", "irqKey6", "irqKey7",
  };

  pKeyData = (keyDataStruct *)kmalloc(sizeof(keyDataStruct), GFP_KERNEL);
  if (!pKeyData)
    return -ENOMEM;

  memset(pKeyData, 0, sizeof(keyDataStruct));

  result = irqKeyInit(pKeyData);
  if (result < 0)
    return result;

  for (int i = 0; i < GPIO_COUNT; i++) {
    // 🚣 Registers an interrupt handler (ISR) for the specified IRQ number.
    result = request_irq(pKeyData->irqKey[i], keyIsr, IRQF_TRIGGER_RISING,
                         irqName[i], pKeyData);
    if (result < 0)
      return result;
  }

  if (openFlag)
    return -EBUSY;
  else
    openFlag = 1;

  if (!try_module_get(THIS_MODULE))
    return -ENODEV;

  filp->private_data = pKeyData;
  return 0;
}
static ssize_t ledkey_read(struct file *filp, char *buf, size_t count,
                           loff_t *f_pos) {
  keyDataStruct *pKeyData = (keyDataStruct *)filp->private_data;

  if (!(filp->f_flags & O_NONBLOCK)) {
    wait_event_interruptible(waitQueueRead, pKeyData->keyNum);
    // 🚣 Uncomment if timeout is required for Non-blocking
    //    wait_event_interruptible_timeout(waitQueueRead, gpioKeyGet(), 100); = 1second
  }

  printk(KERN_DEBUG "call read -> key : %#04x\n", pKeyData->keyNum);

  put_user(pKeyData->keyNum, buf);
  // Or
  // int ret = copy_to_user(buf, &(pKeyData->keyNum), sizeof(pKeyData->keyNum));
  // if (ret < 0)
  //   return ret;

  if (mutex_trylock(&keyMutex) != 0) {
    if (pKeyData->keyNum != 0) {
      pKeyData->keyNum = 0;
    }
  }
  mutex_unlock(&keyMutex);

  return sizeof(pKeyData->keyNum);
}

static ssize_t ledkey_write(struct file *filp, const char *buf, size_t count,
                            loff_t *f_pos) {
  char kbuf;

  get_user(kbuf, buf);
  // Or
  //  int ret;
  //  ret = copy_from_user(&kbuf, buf, sizeof(kbuf));

  printk(KERN_DEBUG "call write -> led : %#04x\n", kbuf);

  ledVal = (int)kbuf;
  return sizeof(kbuf);
}

static __poll_t ledkey_poll(struct file *filp, struct poll_table_struct *wait) {
  keyDataStruct *pKeyData = filp->private_data;
  printk(KERN_DEBUG "_key : %u\n", (wait->_key & POLLIN));
  if (wait->_key & POLLIN)
    poll_wait(filp, &waitQueueRead, wait);
  return pKeyData->keyNum > 0 ? POLLIN : 0;
}

static int ledkey_release(struct inode *inode, struct file *filp) {
  printk(KERN_DEBUG "call release \n");
  keyDataStruct *pKeyData = filp->private_data;

  if (timer_pending(&timerLed)) {
    del_timer(&timerLed);
  }

  irqKeyFree(pKeyData);
  module_put(THIS_MODULE);
  openFlag = 0;

  if (filp->private_data)
    kfree(filp->private_data);
  return 0;
}

// ⚙️ ~ ------------------------------------
static long timer_ioctl(struct file *filp, unsigned int cmd,
                        unsigned long arg) {
  int size = _IOC_SIZE(cmd);
  ledKey_data timer_info = {0};

  printk(KERN_DEBUG "call ioctl -> cmd : %04X\n", cmd);

  if (_IOC_TYPE(cmd) != LEDKEY_IOCTL_MAGIC)
    return -EINVAL;
  if (_IOC_NR(cmd) >= IOCTLTEST_MAXNR)
    return -EINVAL;

  if (size) { // _IOR, _IOW, _IOWR
    if ((_IOC_DIR(cmd) & _IOC_READ) || (_IOC_DIR(cmd) & _IOC_WRITE)) {
      if (!access_ok((void *)arg, size))
        return -EFAULT;
    }
  }

  switch (cmd) {
  case TIMER_START:
    printk(KERN_DEBUG "timerVal : %d , sec : %d \n", timerVal, timerVal / HZ);
    // 🚣 If already regsitered, delete that.
    if (timer_pending(&timerLed))
      del_timer(&timerLed);
    // and start timer
    kernel_timer_registertimer(timerVal);
    return 0;

  case TIMER_STOP:
    if (timer_pending(&timerLed))
      del_timer(&timerLed);
    return 0;

  case TIMER_VALUE:
    if (copy_from_user((void *)&timer_info, (void *)arg, size) != 0)
      return -EFAULT;
    if (timer_info.timer_period > 0)
      timerVal = timer_info.timer_period;
    return 0;

  default:
    return -E2BIG;
  }
  // timer_info.buff[0] = gpioKeyGet();
  // if (timer_info.buff[0] != 0)
  //   timer_info.size = 1;
  // err = copy_to_user((void *)arg, (void *)&timer_info, size);
  // if (err != 0)
  //   return -EFAULT;
  // break;
  // // WRITE
  // err = copy_from_user((void *)&timer_info, (void *)arg, size);
  // if (err != 0)
  //   return -EFAULT;
  // if (timer_info.size == 1)
  //   gpioLedSet(timer_info.buff[0]);
  // break;
  // ------------------------------------
}

/* =========================
 *  File Operations Struct
 * ========================= */
struct file_operations ledkey_fops = {
    .open = ledkey_open,
    .read = ledkey_read,
    .write = ledkey_write,
    .poll = ledkey_poll,
    .release = ledkey_release,
    .unlocked_ioctl = timer_ioctl,
};

/* =========================
 *  Module Init/Exit
 * ========================= */
static int kernel_timer_init(void) {
  printk(KERN_DEBUG "call kernel_timer_init \n");

  int ret;

  mutex_init(&keyMutex);
  ret = gpioLedInit();
  if (ret < 0)
    return ret;

  ret = gpioKeyInit();
  if (ret < 0)
    return ret;

  return register_chrdev(LEDKEY_DEV_MAJOR, LEDKEY_DEV_NAME, &ledkey_fops);
}

static void kernel_timer_exit(void) {
  printk(KERN_DEBUG "call kernel_timer_exit \n");

  if (timer_pending(&timerLed)) {
    del_timer(&timerLed);
  }

  gpioLedFree();
  gpioKeyFree();
  unregister_chrdev(LEDKEY_DEV_MAJOR, LEDKEY_DEV_NAME);
  mutex_destroy(&keyMutex);
}

module_init(kernel_timer_init);
module_exit(kernel_timer_exit);

MODULE_LICENSE("Dual BSD/GPL");
MODULE_AUTHOR("wbfw109v2");
MODULE_DESCRIPTION("Kernel Timer Module");
