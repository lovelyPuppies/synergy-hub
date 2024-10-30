#include <fcntl.h>
#include <poll.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#define DEVICE_FILENAME "/dev/ledkey_dev"

int main(int argc, char *argv[]) {
  int dev;
  char buff;
  int ret;
  int num = 1;
  // ⚙️ ~ ------------------------------------
  // Declare an array of struct pollfd to monitor two file descriptors (stdin and device).
  struct pollfd Events[2];
  // ------------------------------------
  // Declare a buffer to store user input from stdin.
  char keyStr[80];

  if (argc != 2) {
    printf("Usage : %s [led_data(0x00~0xff)]\n", argv[0]);
    return 1;
  }
  buff = (char)strtoul(argv[1], NULL, 16);
  if ((buff < 0x00) || (0xff < buff)) {
    printf("Usage : %s [led_data(0x00~0xff)]\n", argv[0]);
    return 2;
  }

  //  dev = open(DEVICE_FILENAME, O_RDWR | O_NONBLOCK);
  dev = open(DEVICE_FILENAME, O_RDWR);
  if (dev < 0) {
    perror("open");
    return 2;
  }
  write(dev, &buff, sizeof(buff));

  // ⚙️ ~ ------------------------------------
  // Clear the input buffer to ensure clean input processing.
  fflush(stdin);

  // Initialize the Events array to zero to clear any previous data.
  memset(Events, 0, sizeof(Events));

  // Set the first pollfd to monitor stdin for input events.
  Events[0].fd = fileno(stdin);
  // Specify that the event of interest for stdin is "readable data" (POLLIN).
  Events[0].events = POLLIN; // only investigate read event

  // Set the second pollfd to monitor the device file descriptor for input events.
  Events[1].fd = dev;
  // Specify that the event of interest for the device file descriptor is "readable data" (POLLIN).
  Events[1].events = POLLIN;

  // Enter an infinite loop to continuously monitor stdin and device for events.
  while (1) {
    // Call poll to wait for events on the monitored file descriptors for up to 2000ms.
    ret = poll(Events, 2, 2000); //2000ms

    // Check if poll encountered an error.
    if (ret < 0) {
      // Print error message and terminate the program.
      perror("poll");
      exit(1);
    }
    // Check if poll timed out without detecting any events.
    else if (ret == 0) {
      // Print timeout message and continue to the next loop iteration.
      printf("poll time out : %d Sec\n", 2 * num++);
      continue;
    }

    // Title: Event occurred
    // Check if there is a readable event on stdin (Events[0]).
    if (Events[0].revents & POLLIN) {
      // Read a line of input from stdin into the keyStr buffer.
      fgets(keyStr, sizeof(keyStr), stdin);

      // Check if the input string is "q\n" to terminate the program.
      if (!strcmp(keyStr, "q\n"))
        break;
      // Remove the trailing newline character from the input string.
      keyStr[strlen(keyStr) - 1] = '\0'; // '\n' clear

      // Print the input string from stdin.
      printf("STDIN : %s\n", keyStr);

      // Convert the input string to an integer and store it in buff.
      buff = (char)atoi(keyStr);

      if (buff != 0) {
        // Shift 1 left by (buff - 1) bits to set the corresponding LED.
        buff = 1 << (buff - 1);
      }

      // Write the calculated value to the device.
      write(dev, &buff, sizeof(buff));
    }
    // Check if there is a readable event on the device (Events[1]).
    else if (Events[1].revents & POLLIN) {
      // Read data from the device into the buff variable.
      ret = read(dev, &buff, sizeof(buff));

      // Print the key number received from the device.
      printf("key_no : %d\n", buff);

      // Check if the key number is 8 to terminate the program.
      if (buff == 8)
        break;

      // Shift 1 left by (buff - 1) bits to set the corresponding LED.
      buff = 1 << (buff - 1);

      // Write the calculated value to the device.
      write(dev, &buff, sizeof(buff));
    }
  }

  // Close the device file descriptor to release resources.
  close(dev);

  // Return 0 to indicate successful program execution.
  return 0;
}
