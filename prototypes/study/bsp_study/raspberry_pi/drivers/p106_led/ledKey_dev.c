/*
make

ssh r-pi.local '
sudo insmod /mnt/host/drivers/ledKey_dev.ko
lsmod | head -n 5
journalctl -k | tail -n 3
'

ssh r-pi.local '
sudo rmmod ledKey_dev
lsmod | head -n 5
journalctl -k | tail -n 3
'



*/
#include <linux/gpio.h>
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>

#define OFF 0
#define ON  1

#define GPIO_COUNT 8

static int gpioLed[8] = {518, 519, 520, 521, 522, 523, 524, 525};
static int gpioKey[8] = {528, 529, 530, 531, 532, 533, 534, 535};

long fi_ret;

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
      printk("Failed Request gpio%d error\n", gpioKey[i]);
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

static int led_on(void) {
  // printk("Hello, world\n");
  long ret, val;

  gpioLed_init();
  gpioLed_on();

  ret = gpioKey_init();
  fi_ret = ret;
  val = gpioKey_get(ret);
  printk("%ld", val);

  return 0;
}

static void led_off(void) {
  // printk("Goodbye, world.\n");
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

module_init(led_on);
module_exit(led_off);

MODULE_LICENSE("Dual BSD/GPL");
