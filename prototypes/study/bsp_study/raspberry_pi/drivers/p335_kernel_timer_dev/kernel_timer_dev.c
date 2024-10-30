/*
(Incomplete; free..)
Previous:
  make

  ssh r-pi.local '
  sudo insmod /mnt/host/drivers/kernel_timer.ko timerVal=100 ledVal=0x55
  lsmod | head -n 5
  journalctl -k | tail -n 3
  '

  ssh r-pi.local '
  sudo rmmod kernel_timer
  lsmod | head -n 5
  journalctl -k | tail -n 3
  '

Current:
  Terminal 1
    ssh r-pi.local 'journalctl -k --since "now" -f'

  Terminal 2
    ssh r-pi.local '
    sudo mknod /dev/kernel_timer c 230 0
    sudo chmod 666 /dev/kernel_timer
    sudo insmod /mnt/host/drivers/kernel_timer_dev.ko
    '

    ssh -t r-pi.local '/mnt/host/drivers/kernel_timer_app 0xF0'

    ssh r-pi.local 'sudo rmmod kernel_timer_dev'

🪱 context-switching
#!/usr/bin/env fish

# gpioLed와 gpioKey 배열 정의
set gpioLed 518 519 520 521 522 523 524 525
set gpioKey 528 529 530 531 532 533 534 535

# gpioLed와 gpioKey를 합쳐서 처리
for gpio in $gpioLed $gpioKey
    if test -d "/sys/class/gpio/gpio$gpio"
        echo "Unexporting GPIO $gpio"
        echo $gpio > /sys/class/gpio/unexport
    else
        echo "GPIO $gpio is not exported."
    end
end



  버튼을 누르면 
  TODO:
    ioctl 가지고 timer start 명령을 하나 만들어서, 그때 동작하게 하기..


dev.c 만 매일로 보내기

*/
#include "ioctl_test.h"
#include <linux/errno.h>
#include <linux/fcntl.h>
#include <linux/fs.h>
#include <linux/gpio.h>
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/slab.h>
#include <linux/time.h>
#include <linux/timer.h>
#include <linux/types.h>

#define DEBUG 1

#define TIMER_DEV_NAME  "timer"
#define TIMER_DEV_MAJOR 230

#define GPIO_COUNT 8
#define OFF        0
#define ON         1

static int gpioLedInitFlag = 0;
static int gpioKeyInitFlag = 0;

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

// -----------------------------------------
static int timerVal = 100; // f=100Hz, T=1/100 = 10ms, 100*10ms = 1sec
module_param(timerVal, int, 0);
static int ledVal = 0;
module_param(ledVal, int, 0);
struct timer_list timerLed;
// -----------------------------------------

static int ledkey_open(struct inode *inode, struct file *filp) {

#if DEBUG
  int num0 = MAJOR(inode->i_rdev);
  int num1 = MINOR(inode->i_rdev);
  printk("call open -> major : %d\n", num0);
  printk("call open -> minor : %d\n", num1);
#endif

  if (openFlag)
    return -EBUSY;
  else
    openFlag = 1;

  if (!try_module_get(THIS_MODULE))
    return -ENODEV;

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
  char kbuf;

  kbuf = gpioKeyGet();
#if 1
  put_user(kbuf, buf);
#else
  int ret = copy_to_user(buf, &kbuf, sizeof(kbuf));
  if (ret < 0)
    return ret;
#endif

#if DEBUG
  printk("call read -> key : %04X\n", kbuf);
#endif

  return sizeof(kbuf);
}

static ssize_t ledkey_write(struct file *filp, const char *buf, size_t count,
                            loff_t *f_pos) {
  char kbuf; // 1 byte

#if 0
  get_user(kbuf, buf);
#else
  int ret;
  ret = copy_from_user(&kbuf, buf, sizeof(kbuf));
#endif

#if DEBUG
  printk("call write -> led : %04X\n", kbuf);
#endif

  // gpioLedSet(kbuf);
  ledVal = (int)kbuf;

  return sizeof(kbuf);
}

//int ledkey_ioctl (struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
static long ledkey_ioctl(struct file *filp, unsigned int cmd,
                         unsigned long arg) {

  int err = 0;
  int size = 0;
  ioctl_test_info ctrl_info = {0, {0}};

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
  case IOCTLTEST_KEYINIT:
    err = gpioKeyInit();
    break;
  case IOCTLTEST_LEDINIT:
    err = gpioLedInit();
    break;
  case IOCTLTEST_KEYLEDINIT:
    err = gpioKeyInit();
    if (err < 0)
      break;
    err = gpioLedInit();
    if (err < 0)
      break;
    break;
  case IOCTLTEST_KEYLEDFREE:
    gpioKeyFree();
    gpioLedFree();
    break;
  case IOCTLTEST_READ:
    ctrl_info.buff[0] = gpioKeyGet();
    if (ctrl_info.buff[0] != 0)
      ctrl_info.size = 1;
    err = copy_to_user((void *)arg, (void *)&ctrl_info, size);
    if (err != 0)
      return -EFAULT;
    break;
  case IOCTLTEST_GETSTATE:
    err = gpioKeyGet();
    break;
  case IOCTLTEST_LEDON:
    gpioLedSet(0xff);
    break;
  case IOCTLTEST_LEDOFF:
    gpioLedSet(0x00);
    break;
  case IOCTLTEST_WRITE:
    err = copy_from_user((void *)&ctrl_info, (void *)arg, size);
    if (err != 0)
      return -EFAULT;
    if (ctrl_info.size == 1)
      // gpioLedSet(ctrl_info.buff[0]);
      ledVal = ctrl_info.buff[0];
    break;
  case IOCTLTEST_WRITE_READ:
    err = copy_from_user((void *)&ctrl_info, (void *)arg, size);
    if (err != 0)
      return -EFAULT;
    if (ctrl_info.size == 1)
      // gpioLedSet(ctrl_info.buff[0]);
      ledVal = ctrl_info.buff[0];

    ctrl_info.buff[0] = gpioKeyGet();
    if (ctrl_info.buff[0] != 0)
      ctrl_info.size = 1;
    else
      ctrl_info.size = 0;

    err = copy_to_user((void *)arg, (const void *)&ctrl_info, size);
    if (err != 0)
      return -EFAULT;
    break;
  default:
    err = -E2BIG;
    break;
  }
  return err;
}

static int ledkey_release(struct inode *inode, struct file *filp) {
  printk("call release \n");
  if (gpioLedInitFlag)
    gpioLedFree();
  if (gpioKeyInitFlag)
    gpioKeyFree();

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
      printk("Failed request gpio%d error\n", gpioLed[i]);
      return ret;
    }
    ret = gpio_direction_output(gpioLed[i], OFF);
    if (ret < 0) {
      printk("Failed directon_output gpio%d error\n", gpioLed[i]);
      return ret;
    }
  }
  gpioLedInitFlag = 1;
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
  gpioLedInitFlag = 0;
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
  gpioKeyInitFlag = 1;
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
  gpioKeyInitFlag = 0;
}

struct file_operations ledkey_fops = {
    //    .owner    = THIS_MODULE,
    .open = ledkey_open,     .read = ledkey_read,
    .write = ledkey_write,   .unlocked_ioctl = ledkey_ioctl,
    .llseek = ledkey_llseek, .release = ledkey_release,
};

// -----------------------------------------
// callback func
void kernel_timer_func(struct timer_list *t) {
#if DEBUG
  printk("ledVal : %#04x\n", (unsigned int)(ledVal));
#endif
  gpioLedSet(ledVal);

  ledVal = ~ledVal & 0xff;
  // Timer 재설정
  mod_timer(t, get_jiffies_64() + timerVal);
}
void kernel_timer_registertimer(unsigned long timeover) {
  timerLed.expires = get_jiffies_64() + timeover; // 10ms * 100 = 1sec

  // #define timer_setup(timer, callback, flags)
  timer_setup(&timerLed, kernel_timer_func, 0);
  add_timer(&timerLed);
}

int kernel_timer_init(void) {
  int result;
#if DEBUG

  printk("timerVal : %d , sec : %d \n", timerVal, timerVal / HZ);
#endif

  result = register_chrdev(TIMER_DEV_MAJOR, TIMER_DEV_NAME, &ledkey_fops);
  if (result < 0)
    return result;
  result = gpioLedInit();
  if (result < 0)
    //      return result;
    return -EBUSY;
  result = gpioKeyInit();
  if (result < 0)
    return result;

  kernel_timer_registertimer(timerVal);
  return 0;
}

void kernel_timer_exit(void) {
  unregister_chrdev(TIMER_DEV_MAJOR, TIMER_DEV_NAME);
  if (timer_pending(&timerLed))
    del_timer(&timerLed);
  gpioLedSet(0);
  gpioLedFree();
  gpioKeyFree();
}

module_init(kernel_timer_init);
module_exit(kernel_timer_exit);
MODULE_AUTHOR("KCCI-AIOT KSH");
MODULE_DESCRIPTION("led key test module");
MODULE_LICENSE("Dual BSD/GPL");
