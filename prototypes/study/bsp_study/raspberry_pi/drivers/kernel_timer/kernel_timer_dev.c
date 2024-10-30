/*
Edge 디바이스 리눅스 BSP

문항) 입출력 다중화(Poll)와 블록킹 I/O 를 구현한 디바이스 드라이버

* 구현 조건
1. ✔️ Device driver uses
  - ✔️ Poll (I/O 다중화)
  - ✔️ Blocking I/O
    처리할 데이터가 없을 시 프로세스를 대기 상태(Sleep on) 으로 전환하고, key 인터럽트 발생 시 wake up 하여 준비/실행 상태로 전환하여 처리한다.
    ```
    wake_up_interruptible(&waitQueueRead); // in keyIsr()
    wait_event_interruptible(waitQueueRead, pKeyData->keyNum // in ledkey_read()
    ```
2. ✔️ App have arguments: Led value, Timer time
  - ✔️ Exception process: print
    Usage : kernel_timer_app [led_vall(0x00~0xff)] [time_val(1/100)]
  - ✔️ Input Arguments
    ```
    led_no = (char)strtoul(argv[1], NULL, 16);
    timer_val = atoi(argv[2]);
    ```
3. ✔️ use ioctl()
  typedef struct {
    unsigned long timer_val;
  } __attribute__((packed)) ledKey_data;

  // Start kernel timer
  #define TIMER_START _IO(IOCTLTEST_MAGIC, 11)
  // Stop kernel timer
  #define TIMER_STOP _IO(IOCTLTEST_MAGIC, 12)
  // Set cycle of LED On/Off
  #define TIMER_VALUE _IOW(IOCTLTEST_MAGIC, 13, ledKey_data)

4. ✔️ file operations: read() key, write() led
5. ✔️ Operations based on read key
  - key1: ioctl(TIMER_STOP)
  - key2: input timer value
    key2를 입력 시 키보드로 커널 타이머 시간을 100분의 1초 단위로 입력 받아 (TIMER_VALUE)
  - key3: input led value from stdin (0x00~0xff)
    write the led value
  - key4: ioctl(TIMER_STOP)
  - key8: ioctl(TIMER_STOP) with Application close

    and write변경된 값으로 on/off, 및 'Q' 또는 'q' 입력 시 타이머는 멈추고 응용프로세스를 종료.

6. Timer Start 하면 실행되도록. insmod할 때 말고.

*/
#include "ioctl_test.h"
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
#include <linux/types.h>
#include <linux/wait.h>

#define DEBUG 1

#define LEDKEY_DEV_NAME  "ledKey"
#define LEDKEY_DEV_MAJOR 230

#define OFF        0
#define ON         1
#define GPIO_COUNT 8

//static int keyNum = 0;
//static int irqKey[GPIO_COUNT];
typedef struct {
  int keyNum;
  int irqKey[GPIO_COUNT];
} keyDataStruct;

static int gpioLedInit(void);
static void gpioLedSet(long val);
static void gpioLedFree(void);
static int gpioKeyInit(void);
static void gpioKeyFree(void);
static int irqKeyInit(keyDataStruct *pkeyData);
static void irqKeyFree(keyDataStruct *pKeyData);
// ⚙️ ~ ------------------------------------
void kernel_timer_func(struct timer_list *t);
// ------------------------------------

static int gpioLed[GPIO_COUNT] = {518, 519, 520, 521, 522, 523, 524, 525};
static int gpioKey[GPIO_COUNT] = {528, 529, 530, 531, 532, 533, 534, 535};

static int openFlag = 0;

static DEFINE_MUTEX(keyMutex);
static DECLARE_WAIT_QUEUE_HEAD(waitQueueRead);

// ⚙️ ~ ------------------------------------
static int timerVal = 100; // f=100Hz, T=1/100 = 10ms, 100*10ms = 1sec
module_param(timerVal, int, 0);
static int ledVal = 0;
module_param(ledVal, int, 0);
struct timer_list timerLed;

void kernel_timer_registertimer(unsigned long timeover) {
  timerLed.expires = get_jiffies_64() + timeover; // 10ms * 100 = 1sec
  timer_setup(&timerLed, kernel_timer_func, 0);
  add_timer(&timerLed);
}

void kernel_timer_func(struct timer_list *t) {
#if DEBUG
  printk("ledVal : %#04x\n", (unsigned int)(ledVal));
#endif
  gpioLedSet(ledVal);

  ledVal = ~ledVal & 0xff;
  mod_timer(t, get_jiffies_64() + timerVal);
}
// ------------------------------------

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
#if DEBUG
  printk("keyIsr() irq : %d, keyNum : %d\n", irq, pKeyData->keyNum);
#endif
  wake_up_interruptible(&waitQueueRead);
  return IRQ_HANDLED;
}

static int ledkey_open(struct inode *inode, struct file *filp) {

  int result = 0;
  keyDataStruct *pKeyData;
  char *irqName[GPIO_COUNT] = {
      "irqKey0", "irqKey1", "irqKey2", "irqKey3",
      "irqKey4", "irqKey5", "irqKey6", "irqKey7",
  };
#if DEBUG
  int num0 = MAJOR(inode->i_rdev);
  int num1 = MINOR(inode->i_rdev);
  printk("call open -> major : %d\n", num0);
  printk("call open -> minor : %d\n", num1);
#endif

  pKeyData = (keyDataStruct *)kmalloc(sizeof(keyDataStruct), GFP_KERNEL);
  if (!pKeyData)
    return -ENOMEM;

  memset(pKeyData, 0, sizeof(keyDataStruct));

  result = irqKeyInit(pKeyData);
  if (result < 0)
    return result;

  for (int i = 0; i < GPIO_COUNT; i++) {
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
    //		wait_event_interruptible_timeout(waitQueueRead, gpioKeyGet(), 100);	 // 100/HZ = 1sec
  }
#if DEBUG
  printk("call read -> key : %#04x\n", pKeyData->keyNum);
#endif

#if 1
  put_user(pKeyData->keyNum, buf);
#else
  int ret = copy_to_user(buf, &(pKeyData->keyNum), sizeof(pKeyData->keyNum));
  if (ret < 0)
    return ret;
#endif

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

#if 1
  get_user(kbuf, buf);
#else
  int ret;
  ret = copy_from_user(&kbuf, buf, sizeof(kbuf));
#endif

#if DEBUG
  printk("call write -> led : %#04x\n", kbuf);
#endif

  // ⚙️ ~ ------------------------------------
  ledVal = (int)kbuf;
  // gpioLedSet(kbuf);
  // ------------------------------------
  return sizeof(kbuf);
}
static __poll_t ledkey_poll(struct file *filp, struct poll_table_struct *wait) {

  unsigned int mask = 0;
  keyDataStruct *pKeyData = (keyDataStruct *)filp->private_data;
#ifdef DEBUG
  printk("_key : %u\n", (wait->_key & POLLIN));
#endif
  if (wait->_key & POLLIN)
    poll_wait(filp, &waitQueueRead, wait);
  if (pKeyData->keyNum > 0)
    mask = POLLIN;

  return mask;
}
static int ledkey_release(struct inode *inode, struct file *filp) {
  keyDataStruct *pKeyData = (keyDataStruct *)filp->private_data;
  printk("call release \n");
  // ⚙️ ~ ------------------------------------
  if (timer_pending(&timerLed)) {
    del_timer(&timerLed);
  }
  // ------------------------------------
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
  // Initialize values
  int err = 0;
  int size = 0;
  ledKey_data timer_info = {0};

#if DEBUG
  printk("call ioctl -> cmd : %04X\n", cmd);
#endif

  if (_IOC_TYPE(cmd) != IOCTLTEST_MAGIC)
    return -EINVAL;
  if (_IOC_NR(cmd) >= IOCTLTEST_MAXNR)
    return -EINVAL;

  size = _IOC_SIZE(cmd);
  if (size) //_IOR,_IOW,_IOWR
  {
    if ((_IOC_DIR(cmd) & _IOC_READ) || (_IOC_DIR(cmd) & _IOC_WRITE)) {
      err = access_ok((void *)arg, size);
      if (!err)
        return err;
    }
  }

  switch (cmd) {
  case TIMER_START:
#if DEBUG
    printk("timerVal : %d , sec : %d \n", timerVal, timerVal / HZ);
#endif
    // 🚣 If already regsitered, delete that.
    if (timer_pending(&timerLed)) {
      del_timer(&timerLed);
    }
    // and start timer
    kernel_timer_registertimer(timerVal);

    break;
  case TIMER_STOP:
    if (timer_pending(&timerLed)) {
      del_timer(&timerLed);
    }
    break;
  case TIMER_VALUE:
    err = copy_from_user((void *)&timer_info, (void *)arg, size);
    if (err != 0)
      return -EFAULT;
    if (timer_info.timer_val > 0) {
      timerVal = timer_info.timer_val;
    }
    break;
  default:
    err = -E2BIG;
    break;
  }
  return err;
}
// // READ
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

// 🌀 Title: GPIO init ~
static int gpioLedInit(void) {
  int i;
  int ret = 0;
  char gpioName[10];
  for (i = 0; i < GPIO_COUNT; i++) {
    sprintf(gpioName, "led%d", i);
    ret = gpio_request(gpioLed[i], gpioName);
    if (ret < 0) {
      printk("Failed request gpio%d error\n", gpioLed[i]);
      return ret;
    }
    ret = gpio_direction_output(gpioLed[i], OFF);
    if (ret < 0) {
      printk("Failed directon_output gpio%d error\n", gpioLed[i]);
      return ret;
    }
  }
  return ret;
}
static void gpioLedSet(long val) {
  int i;
  for (i = 0; i < GPIO_COUNT; i++) {
    gpio_set_value(gpioLed[i], (val & (0x01 << i)));
  }
}
static void gpioLedFree(void) {
  int i;
  for (i = 0; i < GPIO_COUNT; i++) {
    gpio_free(gpioLed[i]);
  }
}
static int gpioKeyInit(void) {
  int i;
  int ret = 0;
  char gpioName[10];
  for (i = 0; i < GPIO_COUNT; i++) {
    sprintf(gpioName, "key%d", i);
    ret = gpio_request(gpioKey[i], gpioName);
    if (ret < 0) {
      printk("Failed Request gpio%d error\n", gpioKey[i]);
      return ret;
    }
    ret = gpio_direction_input(gpioKey[i]);
    if (ret < 0) {
      printk("Failed direction_output gpio%d error\n", gpioKey[i]);
      return ret;
    }
  }
  return ret;
}
static int irqKeyInit(keyDataStruct *pkeyData) {
  int i;
  int ret = 0;
  for (i = 0; i < GPIO_COUNT; i++) {
    pkeyData->irqKey[i] = gpio_to_irq(gpioKey[i]);
    if (pkeyData->irqKey[i] < 0) {
      printk("Failed gpio_to_irq() gpio%d error\n", gpioKey[i]);
      return pkeyData->irqKey[i];
    }
#if DEBUG
    else
      printk("gpio_to_irq() gpio%d (irq%d) \n", gpioKey[i],
             pkeyData->irqKey[i]);
#endif
  }
  return ret;
}

static void irqKeyFree(keyDataStruct *pKeyData) {
  int i;
  for (i = 0; i < GPIO_COUNT; i++) {
    free_irq(pKeyData->irqKey[i], pKeyData);
  }
}

static void gpioKeyFree(void) {
  int i;
  for (i = 0; i < GPIO_COUNT; i++) {
    gpio_free(gpioKey[i]);
  }
}

struct file_operations ledkey_fops = {
    //    .owner    = THIS_MODULE,
    .open = ledkey_open,
    .read = ledkey_read,
    .write = ledkey_write,
    .poll = ledkey_poll,
    .release = ledkey_release,
    // ⚙️ ~ ------------------------------------
    .unlocked_ioctl = timer_ioctl,
    // ------------------------------------
};
// ⚙️ ~ ------------------------------------
static int kernel_timer_init(void) {
  int result;

  printk("call kernel_timer_init \n");

  mutex_init(&keyMutex);

  result = gpioLedInit();
  if (result < 0)
    return result;

  result = gpioKeyInit();
  if (result < 0)
    return result;

  result = register_chrdev(LEDKEY_DEV_MAJOR, LEDKEY_DEV_NAME, &ledkey_fops);
  if (result < 0)
    return result;

  return 0;
}

static void kernel_timer_exit(void) {
  printk("call kernel_timer_exit \n");
  // ⚙️ ~ ------------------------------------
  if (timer_pending(&timerLed)) {
    del_timer(&timerLed);
  }

  struct gpio_desc *desc = gpio_to_desc(gpioLed[0]);
  if (desc) {
    gpioLedFree();
    gpioKeyFree();
  }
  // ------------------------------------
  unregister_chrdev(LEDKEY_DEV_MAJOR, LEDKEY_DEV_NAME);

  mutex_destroy(&keyMutex);
}

module_init(kernel_timer_init);
module_exit(kernel_timer_exit);

MODULE_LICENSE("Dual BSD/GPL");
MODULE_AUTHOR("wbfw109v2");
MODULE_DESCRIPTION("Kernel Timer module");
// ------------------------------------
