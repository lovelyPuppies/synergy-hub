#ifndef __LEDKEY_IOCTL_H__
#define __LEDKEY_IOCTL_H__

#define LEDKEY_IOCTL_MAGIC '6'
// ⚙️ ~ ------------------------------------
typedef struct {
  unsigned long timer_period;
} __attribute__((packed)) ledKey_data;

#define IOCTLTEST_MAXNR 14
// Start kernel timer
#define TIMER_START _IO(LEDKEY_IOCTL_MAGIC, 11)
// Stop kernel timer
#define TIMER_STOP _IO(LEDKEY_IOCTL_MAGIC, 12)
// Set cycle of LED On/Off
#define TIMER_VALUE _IOW(LEDKEY_IOCTL_MAGIC, 13, ledKey_data)

// ------------------------------------
#endif
