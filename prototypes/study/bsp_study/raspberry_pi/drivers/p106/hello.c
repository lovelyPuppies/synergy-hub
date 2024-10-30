/*
  sudo insmod hello.ko
  lsmod | head -n 5
  journalctl -k | tail -n 3

  sudo rmmod hello
  lsmod | head -n 5
  journalctl -k | tail -n 3

make clean

modinfo hello.ko

📝 Device driver basic includes..
  #include <linux/init.h>
  #include <linux/module.h>
  #include <linux/kernel.h>
  MODULE_LICENSE("Dual BSD/GPL");

*/

#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>
static int hello_init(void) {
  printk("Hellow, world \n");
  return 0;
}
static void hello_exit(void) { printk("Goodbye, world \n"); }

module_init(hello_init);
module_exit(hello_exit);

MODULE_LICENSE("Dual BSD/GPL");
MODULE_AUTHOR("kcci");
MODULE_DESCRIPTION("kcci led key test module");
