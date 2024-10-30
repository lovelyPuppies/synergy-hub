/*
  Terminal 1
    journalctl -k --since "now" -f

  Terminal 2:
    sudo mknod /dev/calldev c 230 0
    sudo chmod 777 /dev/calldev

    sudo insmod call_dev.ko
    ./call_app.out
    sudo rmmod call_dev


make clean

modinfo param.ko

📝 Device driver basic includes..
  #include <linux/init.h>
  #include <linux/module.h>
  #include <linux/kernel.h>
  MODULE_LICENSE("Dual BSD/GPL");

❓ charp

*/

#include <fcntl.h>
#include <stdio.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#define DEVICE_FILENAME "/dev/calldev"

int main() {
  int dev;
  char buff[128];
  int ret;
  printf("1) device file open\n");

  dev = open(DEVICE_FILENAME, O_RDWR | O_NDELAY);
  if (dev >= 0) {
    printf("2) seek function call dev:%d\n", dev);
    ret = lseek(dev, 0x20, SEEK_SET);
    printf("ret = %08X\n", (unsigned int)ret);
    printf("3) read function call\n");
    ret = read(dev, (char *)0x30, 0x31);
    printf("ret = %08X\n", (unsigned int)ret);
    printf("4) write function call\n");
    ret = write(dev, (char *)0x40, 0x41);
    printf("ret = %08X\n", (unsigned int)ret);
    printf("5) ioctxl function call\n");
    ret = ioctl(dev, 0x51, 0x52);
    printf("ret = %08X\n", (unsigned int)ret);
    printf("6) device file close\n");
    ret = close(dev);
    printf("ret = %08X\n", (unsigned int)ret);
  } else {
    perror("open");
  }
  return 0;
}