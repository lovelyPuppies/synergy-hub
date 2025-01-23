/*

Register Address	                      GPIO Pins Controlled
--------------------------------------------------------------------
BCM2711_GPIO_GPFSEL0 (0xFE200000)	      GPIO 0 - GPIO 9
BCM2711_GPIO_GPFSEL1 (0xFE200004)	      GPIO 10 - GPIO 19
BCM2711_GPIO_GPFSEL2 (0xFE200008)	      GPIO 20 - GPIO 29


📰 TODO: printf 대신 puts 쓰기. 최적화.

*/

#include <asm/io.h>
#include <command.h>
#include <vsprintf.h>

#define BCM2711_GPIO_GPFSEL0 0xFE200000
#define BCM2711_GPIO_GPFSEL1 0xFE200004
#define BCM2711_GPIO_GPFSEL2 0xFE200008
#define BCM2711_GPIO_GPSET0 0xFE20001C
#define BCM2711_GPIO_GPCLR0 0xFE200028
#define BCM2711_GPIO_GPLEV0 0xFE200034

#define GPIO6_9_SIG_OUTPUT 0x09240000
// #define GPIO10_13_SIG_OUTPUT  0x00012249  //txd,rxd
#define GPIO10_13_SIG_OUTPUT 0x00000249
unsigned long last_key_state = 0; // Stores the last state of keys

void led_init(void) {
  unsigned long temp;
  temp = readl(BCM2711_GPIO_GPFSEL0); // READ
  temp &= 0x0003ffff;                 // modify(bit clear)
  temp |= GPIO6_9_SIG_OUTPUT;         // modify(bit set: output)
  writel(temp, BCM2711_GPIO_GPFSEL0); // write

  temp = readl(BCM2711_GPIO_GPFSEL1);
  temp &= 0xfffff000;
  temp |= GPIO10_13_SIG_OUTPUT;
  writel(temp, BCM2711_GPIO_GPFSEL1);
}
void key_init(void) {
  // Configure GPIO 16-23 as input
  unsigned long temp;

  temp = readl(BCM2711_GPIO_GPFSEL1);
  // Clear bits for GPIO 16-23
  temp &= ~0xFFFC0000;
  writel(temp, BCM2711_GPIO_GPFSEL1);

  temp = readl(BCM2711_GPIO_GPFSEL2);
  // Clear bits for GPIO 20-23
  temp &= ~0x00000FFF;
  writel(temp, BCM2711_GPIO_GPFSEL2);
}

unsigned long key_read(void) {
  // Return key_state of GPIO 16-23 levels
  return (unsigned long)((readl(BCM2711_GPIO_GPLEV0) >> 16) & 0xFF);
}

void led_write(unsigned long led_data) {
  writel(0X3fc0, BCM2711_GPIO_GPCLR0);   // GPIO 6-13 끄기
  led_data = led_data << 6;              // GPIO 6부터 시작하므로 6비트 시프트
  writel(led_data, BCM2711_GPIO_GPSET0); // GPIO 6-13 켜기
}

void print_led_and_key_state(unsigned long key_state) {
  printf("0:1:2:3:4:5:6:7\n");

  for (int i = 0; i < 8; i++) {
    if (key_state & (1 << i)) {
      printf("O");
    } else {
      printf("X");
    }

    if (i < 7) {
      printf(":");
    }
  }
  printf("\n\n");
}

static int do_KCCI_LED(struct cmd_tbl *cmdtp, int flag, int argc,
                       char *const argv[]) {
  unsigned long led_data, current_key_state;
  if (argc != 2) {
    cmd_usage(cmdtp);
    return 1;
  }
  printf("*LED TEST START\n");
  led_init();
  key_init();

  led_data = simple_strtoul(argv[1], NULL, 16);
  led_write(led_data);

  do {
    // Read the current key state
    current_key_state = key_read();

    // Check if the key state has changed
    if (current_key_state != last_key_state) {
      // Update the LEDs based on the key state
      led_write(current_key_state);

      // Print the current key and LED state
      print_led_and_key_state(current_key_state);

      // Update the last key state
      last_key_state = current_key_state;
    }

    // Break the loop if key 7 (GPIO 23) is pressed; 0b10000000
    if (current_key_state & 0x80) {
      break;
    }
  } while (1);

  printf("LED TEST END(%s : %#04x)\n\n ", argv[0], (unsigned int)led_data);
  return 0;
}
U_BOOT_CMD(led, 2, 0, do_KCCI_LED, "led - kcci LED Test.",
           "number - Input argument is only one.(led [0x00~0xff])\n");
