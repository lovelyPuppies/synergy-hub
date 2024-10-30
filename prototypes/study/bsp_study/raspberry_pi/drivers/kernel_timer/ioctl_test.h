#ifndef __IOCTL_H__
#define __IOCTL_H__

#define IOCTLTEST_MAGIC '6'
// ⚙️ ~ ------------------------------------
typedef struct {
  unsigned long timer_val;
} __attribute__((packed)) ledKey_data;

#define IOCTLTEST_MAXNR 14
// Start kernel timer
#define TIMER_START _IO(IOCTLTEST_MAGIC, 11)
// Stop kernel timer
#define TIMER_STOP _IO(IOCTLTEST_MAGIC, 12)
// Set cycle of LED On/Off
#define TIMER_VALUE _IOW(IOCTLTEST_MAGIC, 13, ledKey_data)

// ------------------------------------
#endif
