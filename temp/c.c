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
// #define GPIO10_13_SIG_OUTPUT 0x00012249 // txd, rxd
#define GPIO10_13_SIG_OUTPUT 0x00000249 txd, rxd

void led_init(void) {
  unsigned long temp;
  temp = readl(BCM2711_GPIO_GPFSEL0); // read
  temp &= 0x0003ffff;                 // modify (bit clear)
  temp |= GPIO6_9_SIG_OUTPUT;         // modify(bit set: output)

  writel(temp, BCM2711_GPIO_GPFSEL0); // write
  temp = readl(BCM2711_GPIO_GPFSEL1);
  temp &= 0xfffff000;
  temp |= BCM2711_GPIO_GPFSEL1;
  writel(temp, BCM2711_GPIO_GPFSEL1); // write
}

void led_write(unsigned long led_data) {
  writel(0x3fc0, BCM2711_GPIO_GPCLR0);
  led_data = led_data << 6;
  writel(led_data, BCM2711_GPIO_GPSET0); // ledX on
}

static int do_KCCILLED(struct cmd_tbl *cmdtp, int flag, int argc,
                       char *const argv[]) {
  unsigned long led_data;
  if (argc != 2) {
    cmd_usage(cmdtp);
    return 1;
  }
  printf("*LED TEST START\n");
  led_init();
  led_data = simple_strtoul(argv[1], NULL, 16);
  led_write(led_data);
  printf("*LED TEST END(%s : %#04x)\n\n ", argv[0], (unsigned int)led_data);
  return 0;
}

// Helpm message: 'kcci LED TEst.'
U_BOOT_CMD(led, 2, 0, do_KCCILLED, "kcci LED Test.",
           "number - Input argument is only one.(led [0x00~0xff])");

// // For printf and NULL
// #include <stdio.h>
// // For strtok
// #include <string.h>

// int main() {
//   // Initialize a string to tokenize
//   char str[] = "hello@world@STM32";
//   char *token;

//   // Print the original string before tokenization
//   printf("Original string: %s\n", str);

//   // First call to strtok
//   token = strtok(str, "@");
//   printf("Token 1: %s\n", token);

//   // Print the string after the first tokenization
//   printf("String after first strtok: %s\n", str);

//   // Second call to strtok
//   token = strtok(NULL, "@");
//   printf("Token 2: %s\n", token);

//   // Print the string after the second tokenization
//   printf("String after second strtok: %s\n", str);

//   // Third call to strtok
//   token = strtok(NULL, "@");
//   printf("Token 3: %s\n", token);

//   // Print the string after the third tokenization
//   printf("String after third strtok: %s\n", str);

//   return 0;
// }

다음 라즈베리파이 4b 의 u - boot 에서 led 명령어로 실행할 코드인데,
    주석 제외하고 자세하게 뭐하는 코드인지 해석해주고,
    이후 TODO를 구현해줘

        // Helpm message: 'kcci LED TEst.'
        U_BOOT_CMD(led, 2, 0, do_KCCILLED, "kcci LED Test.",
                   "number - Input argument is only one.(led [0x00~0xff])");

/* TODO:
Sepc
  - LED는 GPIO 6 ~ 13 (8개) GPIO 사용중.
  - button 은 GPIO 16 ~ 23 (8개) 사용중.

TODO: 버튼을 눌렀을 때 해당 버튼에 1:1 로 매칭되는 LED 제어한 후 key 상태값을 읽어 O, X 로 출력하기.(key7: 종료)

여러 버튼을 누르면 둘이 O 가 나와야 한다.
- 상태가 바뀌었을 때만 출력해야한다. 상태가 유지될 때는 X
U-Boot> led 0x55
*LED TEST START
0:1:2:3:4:5:6:7
X:X:X:X:X:O:X
0:1:2:3:4:5:6:7
X:X:X:X:X:X:O

*/