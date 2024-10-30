/*
Terminal 1
  ssh -t r-pi.local 'journalctl -k --since "now" -f'

Terminal 2
  ssh r-pi.local '
  sudo mknod /dev/ledkey_dev c 230 0
  sudo chmod 666 /dev/ledkey_dev
  '

  ssh r-pi.local 'sudo insmod /mnt/host/drivers/ledkey_dev.ko'

  ssh -t r-pi.local '/mnt/host/drivers/ledkey_app 0x55'

  ssh r-pi.local 'sudo rmmod ledkey_dev'
  
  
  
  ssh r-pi.local 'sudo cat /proc/interrupts'
    인터럽트 발생 횟수 누적..
                                                       
- 디바이스 제어, 시간 처리와 커널 타이머, 인터럽트 처리, 블록킹 I/O, 입출력 다중화


*/

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
#include <linux/types.h>

#define DEBUG 1

#define LEDKEY_DEV_NAME  "ledkey"
#define LEDKEY_DEV_MAJOR 230

#define GPIO_COUNT 8
#define OFF        0
#define ON         1

static int gpioLedInit(void);
static void gpioLedSet(long val);
static void gpioLedFree(void);
static int gpioKeyInit(void);
static void gpioKeyFree(void);

static int gpioLed[GPIO_COUNT] = {518, 519, 520, 521, 522, 523, 524, 525};
static int gpioKey[GPIO_COUNT] = {528, 529, 530, 531, 532, 533, 534, 535};

static int onevalue = 1;
static char *twostring = NULL;
static int openFlag = 0;

module_param(onevalue, int, 0);
module_param(twostring, charp, 0);

// ⚙️ ~ ------------------------------------
static DEFINE_MUTEX(keyMutex);

typedef struct {
  int keyNum;
  int irqKey[GPIO_COUNT];
} keyDataStruct;

static int irqKeyInit(keyDataStruct *pKeyData);
static void irqKeyFree(keyDataStruct *pKeydata);

irqreturn_t keyIsr(int irq, void *data) {
  keyDataStruct *pKeyData = (keyDataStruct *)data;
  for (int i = 0; i < GPIO_COUNT; i++) {
    if (irq == pKeyData->irqKey[i]) {
      if (mutex_trylock(&keyMutex) != 0) {
        pKeyData->keyNum = i + 1;
        mutex_unlock(&keyMutex);
        break;
      }
    }
  }
  printk("keyIsr() irq: %d, keyNum : %d", irq, pKeyData->keyNum);
  return IRQ_HANDLED;
}

// ------------------------------------

static int ledkey_open(struct inode *inode, struct file *filp) {

#if DEBUG
  int num0 = MAJOR(inode->i_rdev);
  int num1 = MINOR(inode->i_rdev);
  printk("call open -> major : %d\n", num0);
  printk("call open -> minor : %d\n", num1);
#endif

  // ⚙️ ~ ------------------------------------
  char *irqName[GPIO_COUNT] = {"irqKey0", "irqKey1", "irqKey2", "irqKey3",
                               "irqKey4", "irqKey5", "irqKey6", "irqKey7"};
  int result = 0;
  // 🪱 GFP: Get Free Pages
  keyDataStruct *pKeyData =
      (keyDataStruct *)kmalloc(sizeof(keyDataStruct), GFP_KERNEL);
  if (!pKeyData) {
    return -ENOMEM;
  }
  memset(pKeyData, 0, sizeof(keyDataStruct));

  //
  result = irqKeyInit(pKeyData);
  if (result < 0) {
    return result;
  }

  //

  for (int i = 0; i < GPIO_COUNT; i++) {
    result = request_irq(pKeyData->irqKey[i], keyIsr, IRQF_TRIGGER_RISING,
                         irqName[i], pKeyData);
    if (result < 0)
      return result;
  }

  // ------------------------------------

  if (openFlag)
    return -EBUSY;
  else
    openFlag = 1;

  if (!try_module_get(THIS_MODULE))
    return -ENODEV;

  // ⚙️ ~ ------------------------------------
  filp->private_data = pKeyData;
  // ----------------------------------------
  return 0;
}

static loff_t ledkey_llseek(struct file *filp, loff_t off, int whence) {
#if DEBUG
  printk("call llseek -> off : %08X, whenec : %08X\n", (unsigned int)off,
         whence);
#endif
  return 0x23;
}

static ssize_t ledkey_read(struct file *filp, char *buf, size_t count,
                           loff_t *f_pos) {
  char kbuf = 0;

  // ⚙️ ~ ------------------------------------
  keyDataStruct *pKeyData = (keyDataStruct *)filp->private_data;

  // kbuf = gpioKeyGet();
  if (mutex_trylock(&keyMutex) != 0) {

    if (pKeyData->keyNum != 0) {
      kbuf = (char)(pKeyData->keyNum);
      pKeyData->keyNum = 0;
    }

    mutex_unlock(&keyMutex);
  }
  // ------------------------------------

#if 1
  put_user(kbuf, buf);
#else
  int ret = copy_to_user(buf, &kbuf, sizeof(kbuf));
  if (ret < 0)
    return ret;
#endif

#if DEBUG
  printk("call read -> key : #%04X\n", kbuf);
#endif

  return sizeof(kbuf);
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
  printk("call write -> led : #%04X\n", kbuf);
#endif

  gpioLedSet(kbuf);
  return sizeof(kbuf);
}

static long ledkey_ioctl(struct file *filp, unsigned int cmd,
                         unsigned long arg) {
  int err = 0;
  return err;
}

static int ledkey_release(struct inode *inode, struct file *filp) {
  // ⚙️ ~ ------------------------------------
  keyDataStruct *pKeyData = (keyDataStruct *)filp->private_data;

  printk("call release \n");
  irqKeyFree(pKeyData);
  // ------------------------------------

#if 0
  if (gpioLedInitFlag)
    gpioLedFree();
  if (gpioKeyInitFlag)
    gpioKeyFree();
#endif

  module_put(THIS_MODULE);
  openFlag = 0;
  // ⚙️ ~ ------------------------------------
  if (filp->private_data) {
    kfree(filp->private_data);
  }
  // ------------------------------------

  return 0;
}
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

// ⚙️ ~ ------------------------------------
static int irqKeyInit(keyDataStruct *pKeyData) {
  int ret = 0;

  // ?? 이 차이?? 지역변수가 죽나?
  int i;

  for (i = 0; i < GPIO_COUNT; i++) {
    pKeyData->irqKey[i] = gpio_to_irq(gpioKey[i]);
    if (pKeyData->irqKey[i] < 0) {
      printk("Failed gpio_to_irq() gpio%d error\n", gpioKey[i]);
      return pKeyData->irqKey[i];
    } else {
#if DEBUG
      printk("gpio_to_irq() gpio%d (irq%d)\n", gpioKey[i], pKeyData->irqKey[i]);
#endif
    }
  }
  return ret;
}

static void irqKeyFree(keyDataStruct *pKeyData) {
  int i;
  for (i = 0; i < GPIO_COUNT; i++) {
    free_irq(pKeyData->irqKey[i], pKeyData);
  }
}

// ------------------------------------

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

static void gpioKeyFree(void) {
  int i;
  for (i = 0; i < GPIO_COUNT; i++) {
    gpio_free(gpioKey[i]);
  }
}

struct file_operations ledkey_fops = {
    //    .owner    = THIS_MODULE,
    .open = ledkey_open,     .read = ledkey_read,
    .write = ledkey_write,   .unlocked_ioctl = ledkey_ioctl,
    .llseek = ledkey_llseek, .release = ledkey_release,
};

static int ledkey_init(void) {
  int result;

  printk("call ledkey_init \n");
  // --------------------------
  mutex_init(&keyMutex);
  // --------------------------

#if 1
  result = gpioLedInit();
  if (result < 0)
    return result;

  result = gpioKeyInit();
  if (result < 0)
    return result;

#endif
  // --------------------------
  result = register_chrdev(LEDKEY_DEV_MAJOR, LEDKEY_DEV_NAME, &ledkey_fops);
  if (result < 0)
    return result;
  // --------------------------

  return 0;
}

static void ledkey_exit(void) {
  printk("call ledkey_exit \n");
  unregister_chrdev(LEDKEY_DEV_MAJOR, LEDKEY_DEV_NAME);
#if 1
  gpioLedFree();
  gpioKeyFree();
  mutex_destroy(&keyMutex);

#endif
}

module_init(ledkey_init);
module_exit(ledkey_exit);

MODULE_LICENSE("Dual BSD/GPL");
MODULE_AUTHOR("kcci");
MODULE_DESCRIPTION("led key test module");
