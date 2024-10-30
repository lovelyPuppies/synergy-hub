#include <linux/gpio.h>
#include <linux/kernel.h>

#define OFF 0
#define ON 1
#define GPIO_COUNT 8
int gpioLedInit(void);
void gpioLed_set(long val);
void gpioLedFree(void);
int gpioKeyInit(void);
int gpioKey_get(void);
void gpioKeyFree(void);

int gpioLed[GPIO_COUNT] = {518, 519, 520, 521, 522, 523, 524, 525};
int gpioKey[GPIO_COUNT] = {528, 529, 530, 531, 532, 533, 534, 535};
long sys_mysyscall(long val) {
  int ret = 0;
  ret = gpioLedInit();
  if (ret < 0)
    return ret;
  gpioLed_set(val);
  gpioLedFree();

  ret = gpioKeyInit();
  if (ret < 0)
    return ret;
  val = gpioKey_get();
  gpioKeyFree();
  return val;
}

int gpioLedInit(void) {
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
void gpioLed_set(long val) {
  int i;
  for (i = 0; i < GPIO_COUNT; i++) {
    gpio_set_value(gpioLed[i], (val & (0x01 << i)));
  }
}
void gpioLedFree(void) {
  int i;
  for (i = 0; i < GPIO_COUNT; i++) {
    gpio_free(gpioLed[i]);
  }
}
int gpioKeyInit(void) {
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
int gpioKey_get(void) {
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
void gpioKeyFree(void) {
  int i;
  for (i = 0; i < GPIO_COUNT; i++) {
    gpio_free(gpioKey[i]);
  }
}
