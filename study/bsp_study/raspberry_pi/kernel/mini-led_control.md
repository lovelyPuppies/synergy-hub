## 📰🎱 ...

### Target board Kernel modifictaion

- ✔️ code include/uapi/asm-generic/unistd.h
  System call 번호 할당

  ```c
  #define **NR_mysyscall 453
  **SYSCALL(\_\_NR_mysyscall, sys_mysyscall)

  #undef **NR_syscalls
  #define **NR_syscalls 454
  ```

- ✔️ code kernel/test_mysyscall.c

  ```c
  #include <linux/kernel.h>

  long sys_mysyscall(long val)
  {
    printk(KERN_INFO "Welcome to KCCI's Embedded System!! app value=%ld\n", val);
    return val * val;
  }
  ```

  **Or**

- .

  ```c
    #include <linux/kernel.h>
    #include <linux/gpio.h>

    #define OFF 0
    #define ON 1
    #define GPIO_COUNT 8

    int gpioLed[8] = { 518, 519, 520, 521, 522, 523, 524, 525 };
    long sys_mysyscall(long val)
    {
      long ret = 0;
      for (int i = 0; i < GPIO_COUNT; i++) {
        ret = gpio_request(gpioLed[i], "led0");
        if (ret < 0) {
          printk("Failed request gpio%d error\n", gpioLed[i]);

          return ret;
        }
      }
      for (int i = 0; i < GPIO_COUNT; i++) {
        ret = gpio_direction_output(gpioLed[i], OFF);
        if (ret < 0) {
          printk("Failed direction_output gpio%d error\n",
                gpioLed[i]);
          return ret;
        }
      }
      for (int i = 0; i < GPIO_COUNT; i++) {
        gpio_set_value(gpioLed[i], (val & (0x01 << i)));
      }
      for (int i = 0; i < GPIO_COUNT; i++) {
        gpio_free(gpioLed[i]);
      }

      return 1;
    }

  ```

- ✔️ code include/linux/syscalls.h

  ```c
    long sys_mysyscall(long val);
    #endif
  ```

- ✔️ code arch/arm/tools/syscall.tbl
  System call 호출 테이블에 처리 함수 등록

  ```
    453 common mysyscall sys_mysyscall
  ```

- ✔️ code kernel/Makefile

  ```
  obj-y ...
  ... test_mysyscall.o
  ```

- ✔️

  ```bash
  #!/usr/bin/env fish
  # get default raspberry_pi .config (one-time)
  #   make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2711_defconfig
  # customize .config (if you want)
  #   make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig


  sudo -v
  # script
  # >>  Script started, output log file is 'typescript'.
  make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage -j8
  # exit

  sudo cp arch/arm/boot/zImage /nfs/class/pi_kernel/kernel7l.img
  ssh r-pi.local '\
    sudo cp /mnt/host/class/pi_kernel/kernel7l.img /boot/firmware/
    sudo reboot
  '
  ```

---

### User application

- Approach via **Syscall**

  ```c
  // 🗄️ temp/syscall_app.c
  #include <stdio.h>
  #include <unistd.h>
  #include <asm-generic/unistd.h>
  #pragma GCC diagnostic ignored "-Wunused-result"
  int main()
  {
    long val;
    printf("intput value = ");
    scanf("%ld", &val);
    printf("\n");
    val = syscall(__NR_mysyscall, val);
    if (val < 0) {
      perror("syscall");
      return 1;
    }
    printf("mysyscall return value = %ld\n", val);
    return 0;
  }
  ```

- ✔️

  ```bash
  #!/usr/bin/env fish
  arm-linux-gnueabihf-gcc temp/syscall_app.c -o temp/syscall_app
  cp temp/syscall_app /nfs/class/pi_kernel/
  echo "50" | ssh r-pi.local '/mnt/host/class/pi_kernel/syscall_app'
  # >> intput value =
  #   mysyscall return value = 2500

  ```

## 🎱 Application - LED Control

- ✔️ kernel/test_mysyscall.c
  System call 호출 함수 구현

  ```c
  #include <linux/kernel.h>
  #include <linux/gpio/consumer.h>
  #include <linux/err.h>
  #include <linux/slab.h>
  #include <linux/module.h>

  #define OFF 0
  #define ON 1
  #define GPIO_COUNT 8

  // Array of GPIO descriptors for LEDs
  struct gpio_desc *gpioLeds[GPIO_COUNT] = { NULL };
  //  6 ~ 13
  static int gpioNumbers[GPIO_COUNT] = { 518, 519, 520, 521, 522, 523, 524, 525 };
  // 16 ~ 23
  static int gpioKey[GPIO_COUNT] = { 528, 529, 530, 531, 532, 533, 534, 535 };

  // Function to initialize GPIOs for LEDs
  int gpioLedInit(void)
  {
    int i, ret;
    char label[16];

    for (i = 0; i < GPIO_COUNT; i++) {
      snprintf(label, sizeof(label), "led%d", i); // led0, led1, ...
      gpioLeds[i] = gpiod_get_index(NULL, "gpiochip0", gpioNumbers[i],
                  GPIOD_OUT_LOW);
      if (IS_ERR(gpioLeds[i])) {
        pr_err("Failed to request GPIO %d for %s\n",
              gpioNumbers[i], label);
        ret = PTR_ERR(gpioLeds[i]);
        gpioLeds[i] = NULL;
        return ret;
      }
    }
    return 0;
  }

  // Function to set LED states based on a bitmask
  void gpioLedSet(long val)
  {
    int i;
    for (i = 0; i < GPIO_COUNT; i++) {
      if (gpioLeds[i]) {
        gpiod_set_value(gpioLeds[i],
            (val & (1 << i)) ? ON : OFF);
      }
    }
  }

  // Function to free the GPIOs for LEDs
  void gpioLedFree(void)
  {
    int i;
    for (i = 0; i < GPIO_COUNT; i++) {
      if (gpioLeds[i]) {
        gpiod_put(gpioLeds[i]);
        gpioLeds[i] = NULL;
      }
    }
  }

  // System call handler for controlling LEDs
  long sys_mysyscall(long val)
  {
    // printk(KERN_INFO "Welcome to KCCI's Embedded System!! app value=%ld\n",
    //        val);
    // return val * val;

    int ret;

    // Initialize GPIOs
    ret = gpioLedInit();
    if (ret < 0) {
      return ret;
    }

    // Set LED values
    gpioLedSet(val);

    // Free GPIOs
    gpioLedFree();

    return 0; // Success
  }

  // Module initialization function
  static int __init led_syscall_init(void)
  {
    pr_info("LED syscall module loaded.\n");
    return 0;
  }

  // Module cleanup functionsys_mysyscall
  static void __exit led_syscall_exit(void)
  {
    pr_info("LED syscall module unloaded.\n");
  }

  module_init(led_syscall_init);
  module_exit(led_syscall_exit);
  ```

- Approach via **Syscall**

  ```c
  #include <stdio.h>
  #include <unistd.h>
  #include <asm-generic/unistd.h> // For custom syscall number

  #define __NR_mysyscall 453 // Replace with your syscall number

  int main()
  {
    long val = 0x0F; // Example bitmask
    printf("Setting GPIO LEDs with mask: 0x%lx\n", val);
    long ret = syscall(__NR_mysyscall, val);
    if (ret < 0) {
      perror("Syscall failed");
      return 1;
    }
    printf("Syscall executed successfully\n");
    return 0;
  }

  ```

- ✔️

  ```bash
  #!/usr/bin/env fish
  arm-linux-gnueabihf-gcc temp/syscall_app_led.c -o temp/syscall_app_led
  cp temp/syscall_app_led /nfs/class/pi_kernel/
  ssh r-pi.local '/mnt/host/class/pi_kernel/syscall_app_led'
  # >> intput value =
  #   mysyscall return value = 2500
  ```
