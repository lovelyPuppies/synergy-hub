/*
Device Drivers (d)
  Misc devices (i)
  Character devices (c)
    Broadcom Char Drivers (d)
bat drivers/char/Kconfig

mkdir kcci_ledkey; and cd kcci_ledkey
cp /home/wbfw109v2/repos/synergy-hub/prototypes/study/bsp_study/raspberry_pi/drivers/p432_ledkey_pool/ledkey_pool_dev.c /home/wbfw109v2/repos/kernels/raspberry-pi/drivers/char/kcci_ledkey/ledkey_dev.c


*/
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>

#include <linux/errno.h>
#include <linux/fcntl.h>
#include <linux/fs.h>
#include <linux/types.h>

#include <linux/gpio.h>
#include <linux/moduleparam.h>

#include <linux/interrupt.h>
#include <linux/irq.h>
#include <linux/mutex.h>
#include <linux/wait.h>
// ⚙️ ~ ------------------------------------
#include <linux/poll.h>
// ------------------------------------

#define DEBUG 1

#define LEDKEY_DEV_NAME  "ledkey"
#define LEDKEY_DEV_MAJOR 230

#define OFF        0
#define ON         1
#define GPIO_COUNT 8

// static int keyNum = 0;
// static int irqKey[GPIO_COUNT];
typedef struct {
  int keyNum;
  int irqKey[GPIO_COUNT];
} keyDataStruct;

static int gpioLedInit(void);
static void gpioLedSet(long val);
static void gpioLedFree(void);
static int gpioKeyInit(void);
// static int gpioKeyGet(void);
static void gpioKeyFree(void);
static int irqKeyInit(keyDataStruct *pkeyData);
static void irqKeyFree(keyDataStruct *pKeyData);

static int gpioLed[GPIO_COUNT] = {518, 519, 520, 521, 522, 523, 524, 525};
static int gpioKey[GPIO_COUNT] = {528, 529, 530, 531, 532, 533, 534, 535};

static int onevalue = 1;
static char *twostring = NULL;
static int openFlag = 0;

static DEFINE_MUTEX(keyMutex);
// ⚙️ ~ ------------------------------------
static DECLARE_WAIT_QUEUE_HEAD(waitQueueRead);
// ------------------------------------

module_param(onevalue, int, 0);
module_param(twostring, charp, 0);

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
  // ⚙️ ~ ------------------------------------
  wake_up_interruptible(&waitQueueRead);
  // ------------------------------------

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

static loff_t ledkey_llseek(struct file *filp, loff_t off, int whence) {
#if DEBUG
  printk("call llseek -> off : %08X, whenec : %08X\n", (unsigned int)off,
         whence);
#endif
  return 0x23;
}

static ssize_t ledkey_read(struct file *filp, char *buf, size_t count,
                           loff_t *f_pos) {
  keyDataStruct *pKeyData = (keyDataStruct *)filp->private_data;

  // ⚙️ ~ ------------------------------------

  //	kbuf=gpioKeyGet();
  if (!(filp->f_flags & O_NONBLOCK)) {
    wait_event_interruptible(waitQueueRead, pKeyData->keyNum);
    // wait_event_interruptible_timeout(waitQueueRead, gpioKeyGet(), 100); // ❔ to use timeout instead of handler.
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

  // Title: initialize buff to default value (0) after (read and copy) value to user.
  if (mutex_trylock(&keyMutex) != 0) {
    if (pKeyData->keyNum != 0) {
      pKeyData->keyNum = 0;
    }
    mutex_unlock(&keyMutex);
  }
  return sizeof(pKeyData->keyNum);
  // ------------------------------------
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

  gpioLedSet(kbuf);
  return sizeof(kbuf);
}

static long ledkey_ioctl(struct file *filp, unsigned int cmd,
                         unsigned long arg) {
  int err = 0;
  return err;
}

// ⚙️ ~ ------------------------------------
// from "struct file_operations"

/**
 * @brief Poll handler for the ledkey device.
 * @param[in] filp Pointer to the file structure representing the opened device.
 * @param[in] wait Pointer to the poll_table_struct for managing poll wait queues.
 * @return Bitmask of poll events (e.g., POLLIN) indicating the state of the device.
 */
static __poll_t ledkey_poll(struct file *filp, struct poll_table_struct *wait) {
  // Initialize a mask variable to hold the events to return to the poll caller.
  unsigned int mask = 0;

  // Retrieve the private data (keyDataStruct) associated with the file.
  keyDataStruct *pKeyData = (keyDataStruct *)filp->private_data;

  // Debugging: Print the key associated with the wait structure if DEBUG is enabled.
#ifdef DEBUG
  printk("_key : %u\n", (wait->_key & POLLIN));
#endif

  // Check if the caller is interested in POLLIN (readable data).
  if (wait->_key & POLLIN) {
    // Add the waitQueueRead queue to the poll wait list for this file.
    poll_wait(filp, &waitQueueRead, wait);
  }

  // If there are pending key events (keyNum > 0), set the mask to POLLIN.
  if (pKeyData->keyNum > 0) {
    mask = POLLIN;
  }

  // Return the event mask to indicate the state of the file descriptor.
  return mask;
}

// ------------------------------------

static int ledkey_release(struct inode *inode, struct file *filp) {
  keyDataStruct *pKeyData = (keyDataStruct *)filp->private_data;
  printk("call release \n");

  irqKeyFree(pKeyData);

  module_put(THIS_MODULE);
  openFlag = 0;

  if (filp->private_data)
    kfree(filp->private_data);
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

#if 0
static int	gpioKeyGet(void)
{
	int i;
	int ret;
	int keyData=0;
	for(i=0;i<GPIO_COUNT;i++)
	{
//		ret=gpio_get_value(gpioKey[i]) << i;
//		keyData |= ret;
		ret=gpio_get_value(gpioKey[i]);
		keyData = keyData | ( ret << i );
	}
	return keyData;
}
#endif
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
    .unlocked_ioctl = ledkey_ioctl,
    .llseek = ledkey_llseek,
    .release = ledkey_release,
    // ⚙️ ~ ------------------------------------
    .poll = ledkey_poll
    // ------------------------------------
};

static int ledkey_init(void) {
  int result;

  printk("call ledkey_init \n");

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

static void ledkey_exit(void) {
  printk("call ledkey_exit \n");

  unregister_chrdev(LEDKEY_DEV_MAJOR, LEDKEY_DEV_NAME);

  gpioLedFree();
  gpioKeyFree();
  mutex_destroy(&keyMutex);
}

module_init(ledkey_init);
module_exit(ledkey_exit);

MODULE_LICENSE("Dual BSD/GPL");
MODULE_AUTHOR("kcci");
MODULE_DESCRIPTION("led key test module");
