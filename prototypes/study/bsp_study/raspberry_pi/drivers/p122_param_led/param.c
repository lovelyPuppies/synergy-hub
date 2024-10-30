/*
  Terminal 1
    journalctl -k --since "now" -f

  Terminal 2:
    sudo insmod param.ko onevalue=255 twostring=\"test msg\"
    lsmod | head -n 5

    sudo rmmod param
    lsmod | head -n 5

make clean

modinfo param.ko

📝 Device driver basic includes..
  #include <linux/init.h>
  #include <linux/module.h>
  #include <linux/kernel.h>
  MODULE_LICENSE("Dual BSD/GPL");

❓ charp

*/

#include <linux/gpio.h>
#include <linux/init.h>
#include <linux/kern_levels.h>

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/moduleparam.h>

#define OFF 0
#define ON 1

#define GPIO_COUNT 8

static int onevalue = 1;
static char *twostring = NULL;
module_param(onevalue, int, 0);
module_param(twostring, charp, 0);
int gpioLed[8] = {518, 519, 520, 521, 522, 523, 524, 525};
int gpioKey[8] = {528, 529, 530, 531, 532, 533, 534, 535};

static long fi_ret;

static long gpioKey_init(void);
static long gpioLed_init(void);
static void gpioLed_set(long val);
static void gpioLed_on(void);
static void gpioLed_off(void);
static void gpioLed_free(void);
static void gpioKey_free(void);
static long gpioKey_get(long data);
static long gpioKey_init(void) {

  char gpioName[10];

  int ret;

  for (int i = 0; i < GPIO_COUNT; i++) {
    sprintf(gpioName, "key%d", i);
    ret = gpio_request(gpioKey[i], gpioName);
    if (ret < 0) {
      printk(KERN_DEBUG "Failed Request gpio%d error\n"
                        "test",
             gpioKey[i]);
      return (long)ret;
    }
  }

  for (int i = 0; i < GPIO_COUNT; i++) {
    ret = gpio_direction_input(gpioKey[i]);
    if (ret < 0) {
      printk("Failed direction_ouput gpio%d error\n", gpioKey[i]);
      return (long)ret;
    }
  }

  return (long)ret;
}

static long gpioLed_init(void) {
  char gpioName[10];

  int ret;

  for (int i = 0; i < GPIO_COUNT; i++) {

    // gpio 516 is port 6
    // gpio 516 is virtual mapped port
    sprintf(gpioName, "led%d", i);
    ret = gpio_request(gpioLed[i], gpioName);
    if (ret < 0) {
      printk("Failed Request gpio%d error\n", gpioLed[i]);
      return (long)ret;
    }
  }

  for (int i = 0; i < GPIO_COUNT; i++) {
    ret = gpio_direction_output(gpioLed[i], ON);
    if (ret < 0) {
      printk("Failed direction_ouput gpio%d error\n", gpioLed[i]);
      return (long)ret;
    }
  }

  return (long)ret;
}

static void gpioLed_set(long val) {
  int i;
  for (i = 0; i < GPIO_COUNT; i++) {
    gpio_set_value(gpioLed[i], (val & (0x01 << i)));
  }
}
static void gpioLed_on(void) {
  // gpioLed_set()
  for (int i = 0; i < GPIO_COUNT; i++)
    gpio_set_value(gpioLed[i], ON);
}

static void gpioLed_off(void) {
  // gpioLed_set()
  for (int i = 0; i < GPIO_COUNT; i++)
    gpio_set_value(gpioLed[i], OFF);
}

static void gpioLed_free(void) {
  // gpioLedFree()
  // close port of gpio
  // file descripter about port of gpio
  for (int i = 0; i < GPIO_COUNT; i++)
    gpio_free(gpioLed[i]);
}

static void gpioKey_free(void) {
  // gpioLedFree()
  // close port of gpio
  // file descripter about port of gpio
  for (int i = 0; i < GPIO_COUNT; i++)
    gpio_free(gpioKey[i]);
}

static long gpioKey_get(long data) {

  for (int i = 0; i < GPIO_COUNT; i++)
    data |= (gpio_get_value(gpioKey[i]) << i);

  return data;
}

static int hello_init(void) {
  printk(KERN_DEBUG "Hello, world [onevalue=%d:twostring=%s]\n test ", onevalue,
         twostring);
  // printk("Hello, world\n");
  long ret, val;

  gpioLed_init();
  gpioLed_set(onevalue);
  // gpioLed_ON();

  ret = gpioKey_init();
  fi_ret = ret;
  val = gpioKey_get(ret);
  printk("%ld", val);

  return 0;
}
static void hello_exit(void) {
  printk("Goodbye, world \n");
  long val;

  gpioLed_off();
  val = gpioKey_get(fi_ret);
  if (val != 0) {
    printk("key : %#04x\n", (unsigned int)val);
  }
  printk("%ld", val);

  gpioLed_free();
  gpioKey_free();
}

module_init(hello_init);
module_exit(hello_exit);

MODULE_AUTHOR("kcci");
MODULE_DESCRIPTION("kcci led key test module");
MODULE_AUTHOR("hi";)
MODULE_LICENSE("Dual BSD/GPL");

/*
#include <linux/kern_levels.h>

#define KERN_EMERG	  KERN_SOH "0"	  ❔ system is unusable
#define KERN_ALERT	  KERN_SOH "1"	  ❔ action must be taken immediately
#define KERN_CRIT	    KERN_SOH "2"	  ❔ critical conditions
#define KERN_ERR	    KERN_SOH "3"	  ❔ error conditions
#define KERN_WARNING	KERN_SOH "4"	  ❔ warning conditions
#define KERN_NOTICE	  KERN_SOH "5"	  ❔ normal but significant condition
#define KERN_INFO	    KERN_SOH "6"	  ❔ informational
#define KERN_DEBUG	  KERN_SOH "7"	  ❔ debug-level messages
*/