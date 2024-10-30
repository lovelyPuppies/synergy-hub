/*
Terminal 1
  ssh r-pi.local 'journalctl -k --since "now" -f'

Terminal 2
  ssh r-pi.local '
  sudo mknod /dev/ioctldev c 230 0
  sudo chmod 666 /dev/ioctldev
  sudo insmod /mnt/host/drivers/ioctl_dev.ko
  '

  ssh -t r-pi.local '/mnt/host/drivers/ioctl_app'

  ssh r-pi.local 'sudo rmmod ioctl_dev  '
  
                                                       
- 디바이스 제어, 시간 처리와 커널 타이머, 인터럽트 처리, 블록킹 I/O, 입출력 다중화


*/
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>

#include <linux/errno.h>
#include <linux/fcntl.h>
#include <linux/fs.h>
#include <linux/types.h>

#include "ioctl_test.h"
#include <linux/gpio.h>
#include <linux/moduleparam.h>

#define DEBUG 1

#define LEDKEY_DEV_NAME  "ledkey"
#define LEDKEY_DEV_MAJOR 230

#define OFF        0
#define ON         1
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

  //    return -ENOMEM;
  return 0;
}

static loff_t ledkey_llseek(struct file *filp, loff_t off, int whence) {
  printk("call llseek -> off : %08X, whenec : %08X\n", (unsigned int)off,
         whence);
  return 0x23;
}

static ssize_t ledkey_read(struct file *filp, char *buf, size_t count,
                           loff_t *f_pos) {
  char kbuf;
  printk("call read -> buf : %08X, count : %08X \n", (unsigned int)buf, count);
  kbuf = gpioKeyGet();
#if 1
  put_user(kbuf, buf);
#else
  int ret = copy_to_user(buf, &kbuf, sizeof(kbuf));
  if (ret < 0)
    return ret;
#endif
  return sizeof(kbuf);
}

static ssize_t ledkey_write(struct file *filp, const char *buf, size_t count,
                            loff_t *f_pos) {
  char kbuf;
  //    printk( "call write -> buf : %08X, count : %08X \n", (unsigned int)buf, count );

#if 1
  get_user(kbuf, buf);
#else
  int ret;
  ret = copy_from_user(&kbuf, buf, sizeof(kbuf));
#endif
  gpioLedSet(kbuf);
  return sizeof(kbuf);
}

/**
 * @brief Handle IOCTL commands for LED and Key operations
 * 
 * @param filp Pointer to the file structure for the device. This represents 
 *             the file descriptor associated with the device and provides context 
 *             about the current state of the file or device instance.
 * 
 * @param cmd IOCTL command code that encodes the details of the operation to be 
 *            performed. 🚣 This 32-bit value is generated using the `_IOC` macro and contains:
 *            - Direction: Specifies the data transfer direction (e.g., read, write, both).
 *            - Type: Identifies the device or driver associated with the command.
 *            - Number: Indicates the specific operation requested by the user.
 *            - Size: Specifies the size of the data to be transferred.
 *            The driver extracts these details from `cmd` using helper macros like `_IOC_DIR`, 
 *            `_IOC_TYPE`, `_IOC_NR`, and `_IOC_SIZE` to validate and interpret the command.
 * 
 * @param arg Argument passed from user space, typically a pointer to a data buffer.
 *            Depending on the command's direction, it may serve as:
 *            - A source of input data (`_IOC_WRITE`): Kernel reads data from this buffer using
 *              `copy_from_user`.
 *            - A destination for output data (`_IOC_READ`): Kernel writes data to this buffer 
 *              using `copy_to_user`.
 *            - A placeholder for bidirectional data (`_IOC_READ | _IOC_WRITE`): Kernel both reads
 *              from and writes to this buffer.
 *            This parameter is validated using `access_ok` to ensure it points to a valid 
 *            user space memory region before any data transfer occurs.
 * 
 * @return long Returns 0 on success, or a negative error code on failure:
 *              - -EINVAL: Invalid command type or command number.
 *              - -EFAULT: Invalid user space memory access detected.
 *              - Other device-specific errors as applicable.
 */

static long ledkey_ioctl(struct file *filp, unsigned int cmd,
                         unsigned long arg) {

  //    printk( "call ioctl -> cmd : %08X, arg : %08X \n", cmd, (unsigned int)arg );
  // Initial setup and variable declarations
  // Initialize error code and size, and prepare the control structure for data exchange
  int err = 0;
  int size = 0;
  ioctl_test_info ctrl_info = {0, {0}};

  // ❔ [validation] Command: Check if the command type matches the expected magic number
  if (_IOC_TYPE(cmd) != IOCTLTEST_MAGIC)
    return -EINVAL; // Return invalid argument error if the type is incorrect

  // ❔ [validation] Command range: Ensure the command number is within the valid range
  if (_IOC_NR(cmd) >= IOCTLTEST_MAXNR)
    return -EINVAL; // Return invalid argument error if the command number is out of bounds

  // ❔ [validation] Data size and access permissions
  // Extract the size of the data being transferred using the command
  size = _IOC_SIZE(cmd);
  if (size) //_IOR,_IOW,_IOWR
  {
    // Check if the command direction involves reading or writing data
    if ((_IOC_DIR(cmd) & _IOC_READ) || (_IOC_DIR(cmd) & _IOC_WRITE)) {
      // Verify user space memory accessibility
      err = access_ok((void *)arg, size);
      if (!err)
        return err; // Return error if access is not permitted
    }
  }
  // cmd
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

  case IOCTLTEST_LEDON:
    gpioLedSet(0xff);
    break;

  case IOCTLTEST_LEDOFF:
    gpioLedSet(0); // Turn off all LEDs
    break;

  case IOCTLTEST_GETSTATE:
    ctrl_info.buff[0] = gpioKeyGet();
    ctrl_info.size = 1;
    err = copy_to_user((void *)arg, &ctrl_info, size);
    if (err != 0)
      return -EFAULT;
    break;

  case IOCTLTEST_WRITE:
    err = copy_from_user(&ctrl_info, (void *)arg, size);
    if (err != 0)
      return -EFAULT;
    gpioLedSet(ctrl_info.buff[0]);
    break;

  case IOCTLTEST_WRITE_READ:
    err = copy_from_user(&ctrl_info, (void *)arg, size);
    if (err != 0)
      return -EFAULT;
    gpioLedSet(ctrl_info.buff[0]);    // Write to LEDs
    ctrl_info.buff[0] = gpioKeyGet(); // Read from keys
    ctrl_info.size = 1;
    err = copy_to_user((void *)arg, &ctrl_info, size);
    if (err != 0)
      return -EFAULT;
    break;

  default:
    return -EINVAL; // Invalid command
  }
  return err;
}

static int ledkey_release(struct inode *inode, struct file *filp) {
  printk("call release \n");
  struct gpio_desc *desc = gpio_to_desc(gpioLed[0]);
  if (desc) {
    gpioLedFree();
    gpioKeyFree();
  }
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
    //    .owner    = THIS_MODULE,
    .open = ledkey_open,     .read = ledkey_read,
    .write = ledkey_write,   .unlocked_ioctl = ledkey_ioctl,
    .llseek = ledkey_llseek, .release = ledkey_release,
};

static int ledkey_init(void) {
  int result;

  printk("call ledkey_init \n");

#if 0
	result = gpioLedInit();
	if(result < 0)
		return result;

	result = gpioKeyInit();
	if(result < 0)
		return result;
#endif

  result = register_chrdev(LEDKEY_DEV_MAJOR, LEDKEY_DEV_NAME, &ledkey_fops);
  if (result < 0)
    return result;

  return 0;
}

static void ledkey_exit(void) {
  printk("call ledkey_exit \n");
  unregister_chrdev(LEDKEY_DEV_MAJOR, LEDKEY_DEV_NAME);
#if 0
	gpioLedFree();
	gpioKeyFree();
#endif
}

module_init(ledkey_init);
module_exit(ledkey_exit);

MODULE_LICENSE("Dual BSD/GPL");
MODULE_AUTHOR("kcci");
MODULE_DESCRIPTION("led key test module");
