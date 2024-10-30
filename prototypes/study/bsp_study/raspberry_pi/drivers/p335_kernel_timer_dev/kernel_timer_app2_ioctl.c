#include "ioctl_test.h"
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#define DEVICE_FILENAME "/dev/kernel_timer"

void print_led(unsigned char);
int main(int argc, char *argv[]) {
  ioctl_test_info info = {0, {0}};
  int dev;
  int state;
  char buff = 0;
  char oldBuff = 0;
  int ret;
  if (argc < 2) {
    printf("USAGE : %s [ledval] \n", argv[0]);
    return 1;
  }
  //	buff = atoi(argv[1]);
  buff = (char)strtoul(argv[1], 0, 16);

  dev = open(DEVICE_FILENAME, O_RDWR | O_NDELAY);
  if (dev < 0) {
    perror("open()");
    return 2;
  }
  // ret = write(dev, &buff, sizeof(buff));
  // if (ret < 0) {
  //   perror("write()");
  //   return 3;
  // }

  ret = ioctl(dev, IOCTLTEST_WRITE_READ, &info);
  if (ret < 0) {
    printf("ret : %d\n", ret);
    perror("ioctl()");
  }

  print_led(buff);

  buff = 0;
  do {

    read(dev, &buff, sizeof(buff));
    //		buff = 1 << buff-1;
    if ((buff != 0) && (oldBuff != buff)) {
      printf("key : %#04x\n", buff);
      write(dev, &buff, sizeof(buff));
      print_led(buff);
      oldBuff = buff;
      if (buff == 0x80) //key:8
        break;
    }
  } while (1);

  close(dev);
  return 0;
}
/**
 * @brief  asdfasfdas
 * @param led ; hello world
 */
void print_led(unsigned char led) {
  int i;
  puts("1:2:3:4:5:6:7:8");
  for (i = 0; i <= 7; i++) {
    if (led & (0x01 << i))
      putchar('O');
    else
      putchar('X');
    if (i < 7)
      putchar(':');
    else
      putchar('\n');
  }
  return;
}
