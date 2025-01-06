/* =========================
 *  Includes and Definitions
 * ========================= */
#include "ioctl_test.h"
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
 *  Function Prototypes
 * ========================= */
void handle_device_input(int dev, char *key_no, ledKey_data *info, char *led_no,
                         int *loopFlag);
void handle_user_input(int dev, char *key_no, ledKey_data *info, char *led_no);
void print_usage(const char *prog_name);

/* =========================
 *  Main Function
 * ========================= */
int main(int argc, char *argv[]) {
  int dev;
  char key_no = 0;
  char led_no;
  char timer_val;
  int ret;
  int loopFlag = 1;
  struct pollfd Events[2];
  ledKey_data info;

  if (argc != 3) {
    print_usage(argv[0]);
    return 1;
  }

  led_no = (char)strtoul(argv[1], NULL, 16);
  if (!(0 <= led_no && led_no <= 255)) {
    print_usage(argv[0]);
    return 2;
  }

  printf("Author: PJS\n");
  timer_val = atoi(argv[2]);
  info.timer_val = timer_val;

  // Open the device
  dev = open(DEVICE_FILENAME, O_RDWR);
  if (dev < 0) {
    perror("open");
    return 2;
  }

  ioctl(dev, TIMER_VALUE, &info);
  write(dev, &led_no, sizeof(led_no));
  ioctl(dev, TIMER_START);

  memset(Events, 0, sizeof(Events));
  Events[0].fd = dev;
  Events[0].events = POLLIN;
  Events[1].fd = fileno(stdin);
  Events[1].events = POLLIN;

  // Main loop
  while (loopFlag) {
    ret = poll(Events, 2, 1000);
    if (ret == 0) {
      continue;
    }

    if (Events[0].revents & POLLIN) {
      handle_device_input(dev, &key_no, &info, &led_no, &loopFlag);
    } else if (Events[1].revents & POLLIN) {
      handle_user_input(dev, &key_no, &info, &led_no);
    }
  }

  close(dev);
  return 0;
}

/* =========================
 *  Helper Functions
 * ========================= */
void print_usage(const char *prog_name) {
  printf("Usage: %s [led_val(0x00~0xff)] [timer_val(1/100)]\n", prog_name);
}

void handle_device_input(int dev, char *key_no, ledKey_data *info, char *led_no,
                         int *loopFlag) {
  read(dev, key_no, sizeof(*key_no));
  printf("key_no: %d\n", *key_no);

  switch (*key_no) {
  case 1:
    printf("TIMER STOP!\n");
    ioctl(dev, TIMER_STOP);
    break;
  case 2:
    ioctl(dev, TIMER_STOP);
    printf("Enter timer value!\n");
    break;
  case 3:
    ioctl(dev, TIMER_STOP);
    printf("Enter LED value!\n");
    break;
  case 4:
    printf("TIMER START!\n");
    ioctl(dev, TIMER_START);
    break;
  case 8:
    printf("APP CLOSE!\n");
    ioctl(dev, TIMER_STOP);
    *loopFlag = 0;
    break;
  }
}

void handle_user_input(int dev, char *key_no, ledKey_data *info, char *led_no) {
  char inputString[80];

  fgets(inputString, sizeof(inputString), stdin);
  inputString[strlen(inputString) - 1] = '\0'; // Remove newline

  if (inputString[0] == 'q' || inputString[0] == 'Q') {
    *key_no = 8; // Simulate app close
    return;
  }

  if (*key_no == 2) { // Timer value
    info->timer_val = atoi(inputString);
    ioctl(dev, TIMER_VALUE, info);
    ioctl(dev, TIMER_START);
  } else if (*key_no == 3) { // LED value
    *led_no = (char)strtoul(inputString, NULL, 16);
    write(dev, led_no, sizeof(*led_no));
    ioctl(dev, TIMER_START);
  }

  *key_no = 0;
}
