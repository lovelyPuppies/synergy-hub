# # Module-specific variables
# MODULE_NAME := $(MODULE_NAME)
# SRC_DIR := src
# BUILD_DIR := $(BUILD_DIR)
# INCLUDE_DIRS := -Iinclude -I../include -fno-pic -Wno-unused-parameter -Wno-sign-compare
# COMPILER := $(COMPILER)
# LINKER := $(LINKER)
# CFLAGS := $(COMMON_CFLAGS) $(INCLUDE_DIRS)

# # Kernel build settings
# KERNEL_DIR := $(KERNEL_DIR)

# # Source files and object files
# SRCS := $(wildcard $(SRC_DIR)/*.c)
# OBJS := $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SRCS))

# # Default target
# default: $(BUILD_DIR)/$(MODULE_NAME).ko

# # Build kernel module
# $(BUILD_DIR)/$(MODULE_NAME).ko: $(OBJS)
# 	@mkdir -p $(BUILD_DIR)
# 	$(MAKE) -C $(KERNEL_DIR) M=$(PWD) O=$(BUILD_DIR) modules ARCH=arm64 \
# 		CC=$(COMPILER) LD=$(LINKER) CFLAGS_MODULE="$(CFLAGS)"

# # Compile source files to object files
# $(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
# 	@mkdir -p $(BUILD_DIR)
# 	$(COMPILER) $(CFLAGS) -c -o $@ $<

# # Clean
# clean:
# 	rm -rf $(BUILD_DIR)
# 	$(MAKE) -C $(KERNEL_DIR) M=$(PWD) clean


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
