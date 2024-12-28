/*
Terminal 1
  journalctl -k --since "now" -f

Terminal 2:
  sudo mknod /dev/ledkey_dev c 230 0
  sudo chmod 777 /dev/ledkey_dev

  sudo insmod /mnt/host/drivers/call_ledkey_dev.ko

  /mnt/host/drivers/call_ledkey_app 0xFF
  
  sudo rmmod call_ledkey_dev


💡
ctrl+z .. -> bg %1
백그라운드로 job 보내기!
lsmod | grep ledkey
fg %1 -> foreground 로 가져오기

아니면 바로 /mnt/host/drivers/call_ledkey_app 0xFF &    백그라운드로 보내기.
jobs
kill -9    or    killall ...

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

#define ledkey_DEV_NAME "calldev"
#define ledkey_DEV_MAJOR 230

#define OFF 0
#define ON 1
#define GPIO_COUNT 8

static int gpioLedInit(void);
static void gpioLedSet(long val);
static void gpioLedFree(void);
static int gpioKeyInit(void);
static int gpioKeyGet(void);
static void gpioKeyFree(void);

static int gpioLed[GPIO_COUNT] = {518, 519, 520, 521, 522, 523, 524, 525};
static int gpioKey[GPIO_COUNT] = {528, 529, 530, 531, 532, 533, 534, 535};

static int onevalue = 1;
static char *twostring = NULL;
static int openFlag = 0;

module_param(onevalue, int, 0);
module_param(twostring, charp, 0);

static int ledkey_open(struct inode *inode, struct file *filp) {
  int num0 = MAJOR(inode->i_rdev);
  int num1 = MINOR(inode->i_rdev);
  printk(KERN_DEBUG "call open -> major : %d\n", num0);
  printk(KERN_DEBUG "call open -> minor : %d\n", num1);

  if (openFlag) {
    return -EBUSY;
  } else {
    openFlag = 1;
  }

  // this snippet must be loated after set openFlag.
  if (!try_module_get(THIS_MODULE)) {
    return -ENODEV;
  }

  return 0;
  // return -ENODEV;
}

static loff_t ledkey_llseek(struct file *filp, loff_t off, int whence) {
  printk(KERN_DEBUG "call llseek -> off : %08X, whenec : %08X\n",
         (unsigned int)off, whence);
  return 0x23;
}

static ssize_t ledkey_read(struct file *filp, char *buf, size_t count,
                           loff_t *f_pos) {
  int ret;
  printk(KERN_DEBUG "call read -> buf : %08X, count : %08X \n",
         (unsigned int)buf, count);
  char kbuf = gpioKeyGet();
  // put_user(kbuf, buf);
  ret = copy_to_user(buf, &kbuf, 1); // 🚣
  return ret;
}

static ssize_t ledkey_write(struct file *filp, const char *buf, size_t count,
                            loff_t *f_pos) {
  int ret;
  printk(KERN_DEBUG "call write -> buf : %08X, count : %08X \n",
         (unsigned int)buf, count);
  char kbuf;
  // get_user(kbuf, buf);
  ret = copy_from_user((void *)buf, &kbuf, 1); // 🚣
  gpioLedSet(kbuf);
  return ret;
}

//int ledkey_ioctl (struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
static long ledkey_ioctl(struct file *filp, unsigned int cmd,
                         unsigned long arg) {

  printk(KERN_DEBUG "call ioctl -> cmd : %08X, arg : %08X \n", cmd,
         (unsigned int)arg);
  return 0x53;
}

static int ledkey_release(struct inode *inode, struct file *filp) {
  printk(KERN_DEBUG "call release \n");
  module_put(THIS_MODULE);
  openFlag = 0;
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
      printk(KERN_DEBUG "Failed request gpio%d error\n", gpioLed[i]);
      return ret;
    }
    ret = gpio_direction_output(gpioLed[i], OFF);
    if (ret < 0) {
      printk(KERN_DEBUG "Failed directon_output gpio%d error\n", gpioLed[i]);
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
      printk(KERN_DEBUG "Failed Request gpio%d error\n", gpioKey[i]);
      return ret;
    }
    ret = gpio_direction_input(gpioKey[i]);
    if (ret < 0) {
      printk(KERN_DEBUG "Failed direction_output gpio%d error\n", gpioKey[i]);
      return ret;
    }
  }
  return ret;
}
static int gpioKeyGet(void) {
  int i;
  int ret;
  int keyData = 0;
  for (i = 0; i < GPIO_COUNT; i++) {
    //		ret=gpio_get_value(gpioKey[i]) << i;
    //		keyData |= ret;
    ret = gpio_get_value(gpioKey[i]);
    keyData = keyData | (ret << i);
  }
  return keyData;
}
static void gpioKeyFree(void) {
  int i;
  for (i = 0; i < GPIO_COUNT; i++) {
    gpio_free(gpioKey[i]);
  }
}

struct file_operations ledkey_fops = {
    // .owner = THIS_MODULE,  // lsmod 시, 모듈 사용 횟수 변수가 가 2개씩 되는 문제
    .open = ledkey_open,     .read = ledkey_read,
    .write = ledkey_write,   .unlocked_ioctl = ledkey_ioctl,
    .llseek = ledkey_llseek, .release = ledkey_release,
};

static int ledkey_init(void) {
  int result;

  printk(KERN_DEBUG "call ledkey_init \n");
  result = gpioLedInit();
  if (result < 0)
    return result;

  result = gpioKeyInit();
  if (result < 0)
    return result;

  result = register_chrdev(ledkey_DEV_MAJOR, ledkey_DEV_NAME, &ledkey_fops);
  if (result < 0)
    return result;

  return 0;
}

static void ledkey_exit(void) {
  printk(KERN_DEBUG "call ledkey_exit \n");
  unregister_chrdev(ledkey_DEV_MAJOR, ledkey_DEV_NAME);
  gpioLedFree();
  gpioKeyFree();
}

module_init(ledkey_init);
module_exit(ledkey_exit);

MODULE_LICENSE("Dual BSD/GPL");
MODULE_AUTHOR("kcci");
MODULE_DESCRIPTION("led key test module");
