# Kernel module name (no application)
MODULE_NAME := ledKey_dev
obj-m := $(MODULE_NAME).o

# Paths
KERNEL_DIR := $(HOME)/repos/kernels/raspberry-pi
MODULE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# Target architecture and compiler settings
KERNEL_ARCHITECTURE := arm  # Target architecture (ARM)
COMPILER := clang
LINKER := ld.lld

# Clang flags for the kernel module
TARGET_TOOLCHAIN := arm-linux-gnueabihf  	# Target toolchain prefix
CPU_ARCH_FLAGS := -march=armv8-a  				# Specify ARMv8-A architecture

# Flags for kernel module compilation
CLANG_FLAGS := --target=$(TARGET_TOOLCHAIN) $(CPU_ARCH_FLAGS) \
	-Wall -Wextra \
	-Wno-unused-parameter -Wno-sign-compare

# Default target: build and deploy kernel module only
default: build deploy

# Build the kernel module
build:
	$(MAKE) -C $(KERNEL_DIR) M=$(MODULE_DIR) modules ARCH=$(KERNEL_ARCHITECTURE) \
	CC=$(COMPILER) LD=$(LINKER) KBUILD_CFLAGS="$(CLANG_FLAGS)"

# Deploy kernel module
deploy:
	cp $(MODULE_NAME).ko /nfs/drivers  # Copy the kernel module

# Clean up build artifacts
clean:
	rm -rf *.ko                   # Remove kernel object files
	rm -rf *.mod.*                # Remove module-related files
	rm -rf .*.cmd                 # Remove temporary build files
	rm -rf *.o                    # Remove object files
	rm -rf modules.order          # Remove module order file
	rm -rf Module.symvers         # Remove symbol versioning file
	rm -rf .tmp_versions          # Remove temporary versioning files
	rm -rf $(MODULE_NAME).mod     # Remove module metadata
