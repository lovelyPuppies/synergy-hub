# Kernel module name
obj-m := kernel_timer_dev.o

# Add include directories
EXTRA_CFLAGS += -I$(M)/include -I$(M)/../include

# Source file path
kernel_timer_dev-objs := src/kernel_timer_dev.o

# Default target
default: build

# Build the kernel module
build:
	$(MAKE) -C $(KERNEL_DIR) M=$(PWD) O=$(BUILD_DIR) modules

# Clean artifacts
clean:
	$(MAKE) -C $(KERNEL_DIR) M=$(PWD) O=$(BUILD_DIR) clean
