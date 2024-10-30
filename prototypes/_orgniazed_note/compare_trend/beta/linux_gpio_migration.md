# Transitioning from Legacy GPIO Interface to the Character Device GPIO Interface

## Overview

The Linux kernel has deprecated the legacy GPIO interface (`/sys/class/gpio` and `/sys/kernel/debug/gpio`) in favor of the **Character Device GPIO Interface**. The new interface provides a more robust and flexible way to manage GPIOs, particularly in modern kernels. This document outlines the issues with legacy APIs and presents solutions using the new GPIO descriptor-based API (`libgpiod`).

---

## Why Move Away from Legacy GPIO Interface?

### Legacy GPIO Issues

1. **Hardcoded GPIO Numbers**:
   - Legacy APIs require direct GPIO pin numbers, which are prone to errors and difficult to manage.
2. **Deprecated APIs**:
   - Functions like `gpio_request`, `gpio_free`, `gpio_set_value` are no longer recommended in modern kernels.
3. **Limited Usability**:
   - The old `/sys/class/gpio` interface is static and lacks flexibility.

### New Character Device Interface

The new interface, introduced in Linux 4.8+, provides:

- **Dynamic GPIO Management**:
  - Use names instead of hardcoded numbers.
- **Improved Debugging**:
  - Tools like `gpioinfo` and `gpiodetect` help identify GPIO lines and their states.
- **Better Integration**:
  - Aligns with the device tree for GPIO configurations.

---

## Code Example: Transitioning to `gpiod` API

### Legacy GPIO Code

Below is a legacy GPIO example:

```c
#include <linux/kernel.h>
#include <linux/gpio.h>

#define OFF 0
#define ON 1

long sys_mysycall(long val)
{
    long ret = 0;

    gpio_free(6);  // Release GPIO 6
    ret = gpio_request(6, "led0");
    if (ret < 0) {
        printk("Failed to request gpio%d error
", 6);
        return ret;
    }

    ret = gpio_direction_output(6, OFF);
    if (ret < 0) {
        printk("Failed direction_output gpio%d error
", 6);
        return ret;
    }

    gpio_set_value(6, (int)val);
    gpio_free(6);  // Release GPIO 6

    return 1;
}
```

This code uses deprecated functions and hardcoded GPIO numbers, which can fail in newer kernels.

---

### Updated Code with `gpiod` API

The modern GPIO API uses GPIO descriptors and names defined in the device tree.

```c
#include <linux/gpio/consumer.h>
#include <linux/kernel.h>

#define OFF 0
#define ON 1

long sys_mysycall(long val)
{
    struct gpio_desc *led_gpio;
    int ret;

    // Request GPIO descriptor
    led_gpio = gpiod_get(NULL, "led0", GPIOD_OUT_LOW);
    if (IS_ERR(led_gpio)) {
        printk("Failed to request gpio descriptor for 'led0'
");
        return PTR_ERR(led_gpio);
    }

    // Set GPIO value
    gpiod_set_value(led_gpio, (int)val);

    // Release GPIO descriptor
    gpiod_put(led_gpio);

    return 1;
}
```

### Key Changes

1. **GPIO Names**:
   - `"led0"` refers to a named GPIO in the device tree or board configuration.
2. **`gpiod_get` and `gpiod_put`**:
   - Replace `gpio_request` and `gpio_free`.
3. **`gpiod_set_value`**:
   - Replaces `gpio_set_value`.

---

## Device Tree Configuration

To use GPIO names in the new API, the device tree must define GPIO lines:

```dts
leds {
    compatible = "gpio-leds";
    led0 {
        label = "led0";
        gpios = <&gpio0 6 GPIO_ACTIVE_HIGH>;
    };
};
```

- **`label`**: Name used in the code (`led0`).
- **`gpios`**: GPIO controller reference, pin number, and configuration.

---

## Using `libgpiod-tools` for Debugging

The `libgpiod` library provides command-line tools for managing GPIOs:

1. **Detect GPIO Controllers**:

   ```bash
   gpiodetect
   ```

   Output:

   ```
   gpiochip0 [30200000.gpio] (32 lines)
   gpiochip1 [30210000.gpio] (32 lines)
   ```

2. **View GPIO States**:

   ```bash
   gpioinfo
   ```

3. **Set GPIO Values**:
   ```bash
   gpioset gpiochip0 6=1
   ```

---

## Conclusion

The new Character Device GPIO Interface offers a safer, more maintainable, and flexible method for GPIO management. Transitioning to `gpiod` APIs and ensuring proper device tree configuration will ensure compatibility with modern Linux kernels and improved debugging capabilities.

### Benefits of the New Interface

- Eliminate hardcoded GPIO numbers.
- Enable dynamic GPIO management via descriptors.
- Leverage device tree configurations for cleaner and more maintainable code.

### References

- [Linux Kernel Documentation: GPIO](https://www.kernel.org/doc/Documentation/gpio/)
- [libgpiod Tools](https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/)
- [Buildroot GPIO Configuration](https://buildroot.org/)
