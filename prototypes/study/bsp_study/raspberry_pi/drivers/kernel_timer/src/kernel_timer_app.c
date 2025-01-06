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

  // Variable declarations
  int dev;
  char key_no = 0;
  char led_no;
  char timer_val;
  int ret;
  int loopFlag = 1;
  struct pollfd Events[2];
  ledKey_data info;

  // Validate input arguments
  if (argc != 3) {
    print_usage(argv[0]);
    return 1;
  }

  // Parse and validate LED value
  led_no = (char)strtoul(argv[1], NULL, 16);
  if (!(0 <= led_no && led_no <= 255)) {
    print_usage(argv[0]);
    return 2;
  }

  printf("Author: PJS\n");

  // Parse timer value
  timer_val = atoi(argv[2]);
  info.timer_val = timer_val;

  // Open the device for read and write operations
  dev = open(DEVICE_FILENAME, O_RDWR);
  if (dev < 0) {
    perror("open");
    return 2;
  }

  // Set the timer value and start the timer
  ioctl(dev, TIMER_VALUE, &info);
  write(dev, &led_no, sizeof(led_no));
  ioctl(dev, TIMER_START);

  // Initialize poll events for device and standard input
  memset(Events, 0, sizeof(Events));
  Events[0].fd = dev;           // Device file descriptor
  Events[0].events = POLLIN;    // Ready to read
  Events[1].fd = fileno(stdin); // Standard input
  Events[1].events = POLLIN;    // Ready to read

  // Main loop to handle polling
  while (loopFlag) {
    // Poll for events with a 1-second timeout
    ret = poll(Events, 2, 1000);
    if (ret == 0) {
      continue; // Timeout occurred
    }

    if (Events[0].revents & POLLIN) {
      // Handle input from the device
      handle_device_input(dev, &key_no, &info, &led_no, &loopFlag);
    } else if (Events[1].revents & POLLIN) {
      // Handle input from the user
      handle_user_input(dev, &key_no, &info, &led_no);
    }
  }

  // Close the device before exiting
  close(dev);
  return 0;
}

/* =========================
 *  Helper Functions
 * ========================= */
void print_usage(const char *prog_name) {
  // Print usage instructions
  printf("Usage: %s [led_val(0x00~0xff)] [timer_val(1/100)]\n", prog_name);
}

/**
 * @brief Handles input events from the device.
 *
 * This function processes events received from the device and performs
 * actions based on the key input value. It handles actions such as stopping
 * the timer, updating values, or closing the application.
 *
 * @param dev       File descriptor for the device.
 * @param key_no    Pointer to the variable storing the key input value.
 * @param info      Pointer to the ledKey_data structure for device configuration.
 * @param led_no    Pointer to the LED value to be updated.
 * @param loopFlag  Pointer to the loop control flag. Modified to exit the loop.
 */
void handle_device_input(int dev, char *key_no, ledKey_data *info, char *led_no,
                         int *loopFlag) {
  // Read key input from device
  read(dev, key_no, sizeof(*key_no));
  printf("key_no: %d\n", *key_no);

  switch (*key_no) {
  case 1:
    // Stop the timer
    printf("TIMER STOP!\n");
    ioctl(dev, TIMER_STOP);
    break;
  case 2:
    // Stop the timer before setting a new value
    ioctl(dev, TIMER_STOP);
    printf("Enter timer value!\n");
    break;
  case 3:
    // Stop the timer before setting a new LED value
    ioctl(dev, TIMER_STOP);
    printf("Enter LED value!\n");
    break;
  case 4:
    // Start the timer
    printf("TIMER START!\n");
    ioctl(dev, TIMER_START);
    break;
  case 8:
    // Exit the application
    printf("APP CLOSE!\n");
    ioctl(dev, TIMER_STOP);
    *loopFlag = 0;
    break;
  }
}
/**
 * @brief Handles user input from the keyboard.
 *
 * This function reads user input from the standard input and updates
 * the device's timer or LED value accordingly. It also processes exit
 * commands to terminate the application.
 *
 * @param dev       File descriptor for the device.
 * @param key_no    Pointer to the variable storing the current key input value.
 * @param info      Pointer to the ledKey_data structure for device configuration.
 * @param led_no    Pointer to the LED value to be updated.
 */
void handle_user_input(int dev, char *key_no, ledKey_data *info, char *led_no) {
  // Buffer for user input
  char inputString[80];

  // Get user input
  fgets(inputString, sizeof(inputString), stdin);
  inputString[strlen(inputString) - 1] = '\0'; // Remove newline character

  if (inputString[0] == 'q' || inputString[0] == 'Q') {
    // Simulate app close
    *key_no = 8;
    return;
  }

  if (*key_no == 2) {
    // Set new timer value
    info->timer_val = atoi(inputString); // Convert input to integer timer value
    ioctl(dev, TIMER_VALUE, info);       // Update timer value
    ioctl(dev, TIMER_START);             // Restart the timer
  } else if (*key_no == 3) {
    // Set new LED value
    *led_no =
        (char)strtoul(inputString, NULL, 16); // Convert input to hex LED value
    write(dev, led_no, sizeof(*led_no));      // Update LED value on device
    ioctl(dev, TIMER_START);                  // Restart the timer
  }

  // Reset key input
  *key_no = 0;
}
