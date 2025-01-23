#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#define DEVICE_FILENAME "/dev/ledkey_dev"

void print_led(char *);
void print_key(char *);
int main(int argc, char *argv[]) {
  int dev;
  char buff[8] = {0};
  char oldBuff[8] = {0};
  char buffOff[8] = {0};
  int ret;

  if (argc < 2) {
    printf("USAGE : %s [ledval] \n", argv[0]);
    return 1;
  }
  //	buff = atoi(argv[1]);
  // buff = strtoul(argv[1], NULL, 16);

  if (strlen(argv[1]) != 8) {
    printf(
        "ERROR: Input must be an 8-character binary string (e.g., 11110000)\n");
    return 2;
  }

  // printf("buff : %d\n", buff);
  for (int i = 0; i < 8; i++) {
    if (argv[1][i] == '1') {
      buff[i] = '1';
    } else if (argv[1][i] == '0') {
      buff[i] = '0';
    } else {
      printf(
          "ERROR: Invalid character in input. Only '0' and '1' are allowed.\n");
      return 3;
    }
  }

  //
  dev = open(DEVICE_FILENAME, O_RDWR | O_NDELAY);
  if (dev < 0) {
    perror("open()");
    return 2;
  }
  

  ret = write(dev, buff, sizeof(buff));
  if (ret < 0) {
    perror("write()");
    return 3;
  }

  print_led(buff);
  memset(buff, 0, sizeof(buff));
  do {
    usleep(100000);
    read(dev, buff, sizeof(buff));
    // 📍~
    if (memcmp(buff, buffOff, sizeof(buff))) { // if non-zero value exists
      if (memcmp(buff, oldBuff, sizeof(buff))) { // if current value is different with previous value value.
        print_led(buff);
        write(dev, buff, sizeof(buff));
        if (buff[7] == 1)
          break;
        putchar('\n');
      }
      memcpy(oldBuff, buff, sizeof(buff));
    }
  } while (1);

  close(dev);
  return 0;
}

void print_led(char *led) {
  int i;
  // puts("1:2:3:4:5:6:7:8");
  for (i = 0; i < 8; i++) {
    putchar(led[i] ? 'O' : 'X');
    if (i < 7)
      putchar(':');
    else
      putchar('\n');
  }
}

void print_key(char *key) {
  int i;
  puts("1:2:3:4:5:6:7:8");
  for (i = 0; i < 8; i++) {
    putchar(key[i] ? 'O' : 'X');
    if (i < 7)
      putchar(':');
    else
      putchar('\n');
  }
}
