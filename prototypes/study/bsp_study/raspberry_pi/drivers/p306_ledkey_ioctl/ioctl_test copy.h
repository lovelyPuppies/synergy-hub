#ifndef __IOCTL_H__
#define __IOCTL_H__

#define IOCTLTEST_MAGIC '6' // 0x36
typedef struct {
  unsigned long size;
  unsigned char buff[128];
} __attribute__((packed)) ioctl_test_info;

#define IOCTLTEST_KEYLEDINIT _IO(IOCTLTEST_MAGIC, 0)
#define IOCTLTEST_KEYINIT    _IO(IOCTLTEST_MAGIC, 1)
#define IOCTLTEST_LEDINIT    _IO(IOCTLTEST_MAGIC, 2)
#define IOCTLTEST_READ       _IOR(IOCTLTEST_MAGIC, 3, ioctl_test_info)
#define IOCTLTEST_LEDON      _IO(IOCTLTEST_MAGIC, 4)
#define IOCTLTEST_LEDOFF     _IO(IOCTLTEST_MAGIC, 6)
#define IOCTLTEST_GETSTATE   _IO(IOCTLTEST_MAGIC, 5)
#define IOCTLTEST_WRITE      _IOW(IOCTLTEST_MAGIC, 7, ioctl_test_info)
#define IOCTLTEST_WRITE_READ _IOWR(IOCTLTEST_MAGIC, 8, ioctl_test_info)
#define IOCTLTEST_KEYLEDFREE _IO(IOCTLTEST_MAGIC, 9)
#define IOCTLTEST_MAXNR      10

#endif

/* 📝
🪱 IOC: I/O Control
🪱 dir: Direction of data transmission
🪱 type: Type of the command;     // This file use the name as IOCTLTEST_MAGIC
🪱 nr: Number of the command
🪱 size: Size of the data

#define _IOC(dir,type,nr,size) \
  (((dir)  << _IOC_DIRSHIFT) | \
  ((type) << _IOC_TYPESHIFT) | \
  ((nr)   << _IOC_NRSHIFT) | \
  ((size) << _IOC_SIZESHIFT))



#define _IOC_NRBITS	8
#define _IOC_TYPEBITS	8

#ifndef _IOC_SIZEBITS
# define _IOC_SIZEBITS	14
#endif

#ifndef _IOC_DIRBITS
# define _IOC_DIRBITS	2
#endif

#define _IOC_NRMASK	((1 << _IOC_NRBITS)-1)
#define _IOC_TYPEMASK	((1 << _IOC_TYPEBITS)-1)
#define _IOC_SIZEMASK	((1 << _IOC_SIZEBITS)-1)
#define _IOC_DIRMASK	((1 << _IOC_DIRBITS)-1)

#define _IOC_NRSHIFT	0
#define _IOC_TYPESHIFT	(_IOC_NRSHIFT+_IOC_NRBITS)
#define _IOC_SIZESHIFT	(_IOC_TYPESHIFT+_IOC_TYPEBITS)
#define _IOC_DIRSHIFT	(_IOC_SIZESHIFT+_IOC_SIZEBITS)

*/