/* =========================
 *  Includes and Definitions
 * ========================= */
#include "uapi/ledkey_ioctl.h"
#include <fcntl.h>
#include <poll.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#define DEVICE_FILENAME "/dev/ledKey_dev"
/* =========================
 *  Global Variables
 * ========================= */

/* =========================
 *  Function Prototypes
 * ========================= */
void print_usage(const char *prog_name);
int open_device();
void write_timer_period(int dev, ledKey_data *info, int timer_period);
void write_led(int dev, unsigned char led_value);
void start_timer(int dev);
void stop_timer(int dev);
void initialize_device(int dev, ledKey_data *info, unsigned char led_value,
                       int timer_val);
void handle_polling(int dev);

/* =========================
 *  Main Function
 * ========================= */

int main(int argc, char *argv[]) {
  // 🌀

  if (argc != 3) {
    print_usage(argv[0]);
    return 1;
  }

  unsigned char led_value = (unsigned char)strtoul(argv[1], NULL, 16);
  if (!(0 <= led_value && led_value <= 255)) {
    print_usage(argv[0]);
    return 2;
  }

  int dev = open_device();
  if (dev < 0) {
    return 2;
  }

  // 🌀
  printf("Author: PJS\n");

  // 🌀
  int timer_period = atoi(argv[2]);
  ledKey_data info;

  initialize_device(dev, &info, led_value, timer_period);
  handle_polling(dev);

  close(dev);
  return 0;
}

/* =========================
 *  Helper Functions
 * ========================= */

void print_usage(const char *prog_name) {
  printf("Usage : %s [led_value(0x00~0xff)] [timer_value(1/250) (64bit)]\n",
         prog_name);
}

int open_device() {
  // dev = open(DEVICE_FILENAME, O_RDWR | O_NONBLOCK);
  int dev = open(DEVICE_FILENAME, O_RDWR);
  if (dev < 0) {
    perror("open");
  }
  return dev;
}

void write_timer_period(int dev, ledKey_data *info, int timer_period) {
  info->timer_period = timer_period;
  ioctl(dev, TIMER_VALUE, info);
}

void write_led(int dev, unsigned char led_value) {
  write(dev, &led_value, sizeof(led_value));
}

void start_timer(int dev) { ioctl(dev, TIMER_START); }
void stop_timer(int dev) { ioctl(dev, TIMER_STOP); }

void initialize_device(int dev, ledKey_data *info, unsigned char led_value,
                       int timer_period) {
  write_timer_period(dev, info, timer_period);
  write_led(dev, led_value);
  start_timer(dev);
}

void handle_polling(int dev) {
  /*
    struct pollfd
      {
        int fd;			        // File descriptor to poll.
        short int events;		// Types of events poller 🚣 cares about.
        short int revents;	// revents (Returned Events). Types of events that 🚣 actually occurred.
  */
  struct pollfd Events[2];

  // Next line initializes the `Events` array to zero.
  //  This ensures no residual data is present before setting specific pollfd attributes.
  memset(Events, 0, sizeof(Events));

  // Associates the first pollfd entry with the device file descriptor `dev`. (🚣 not fixed)
  Events[0].fd = dev;
  // Sets the event type to POLLIN, indicating interest in data readiness for reading.
  Events[0].events = POLLIN;

  // Associates the second pollfd entry with the standard input file descriptor. (🚣 reserved)
  Events[1].fd = fileno(stdin);
  Events[1].events = POLLIN;

  int loopFlag = 1;
  char button_key_no;
  char inputString[80];
  // ❗ char timer_value; is managed by `ledKey_data` struct while led_value is directly managed.
  char led_value;

  ledKey_data info;

  while (loopFlag) {
    int ret = poll(Events, 2, 1000);
    if (ret == 0) {
      continue;
    }

    if (Events[0].revents & POLLIN) {
      read(dev, &button_key_no, sizeof(button_key_no));
      printf("button_key_no : %d\n", button_key_no);

      switch (button_key_no) {
      case 1:
        printf("TIMER STOP! \n");
        stop_timer(dev);
        break;
      case 2:
        stop_timer(dev);
        printf("Enter timer value! \n");
        break;
      case 3:
        stop_timer(dev);
        printf("Enter led value! (as ❗ Hex value; 🛍️ e.g.  0xFF) \n");
        break;
      case 4:
        printf("TIMER START! \n");
        start_timer(dev);
        break;
      case 8:
        printf("APP CLOSE ! \n");
        stop_timer(dev);
        loopFlag = 0;
        break;
      }

    } else if (Events[1].revents & POLLIN) {
      // ❔ `else if (Events[1].revents & POLLIN)`; When POLLIN event is triggered, it means stdin has data ready to be read (including newline character).

      // ❔ ``; Flush any leftover characters, including newline characters, in the stdin buffer to ensure clean input.
      //  This ensures no unwanted characters (such as previous line's leftover newlines) interfere with the current input.
      fflush(stdin);

      fgets(inputString, sizeof(inputString), stdin);
      if ((inputString[0] == 'q') || (inputString[0] == 'Q')) {
        break;
      }
      // Next line replaces the newline character at the end of the user input (from fgets) with a null terminator (`\0`).
      //  Ensures the string is properly terminated and avoids issues when processing the input.
      inputString[strlen(inputString) - 1] = '\0';

      if (button_key_no == 2) //timer value
      {
        write_timer_period(dev, &info, atoi(inputString));
        start_timer(dev);

      } else if (button_key_no == 3) //led value
      {
        write(dev, &led_value, sizeof(led_value));
        led_value = (unsigned char)strtoul(inputString, NULL, 16);

        write_led(dev, led_value);
        start_timer(dev);
      }
      button_key_no = 0;
    }
  }
}
