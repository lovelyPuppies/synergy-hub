# Application and kernel module names
APP_NAME := p527_ledkey_app
MODULE_NAME := p527_ledkey_dev
obj-m := $(MODULE_NAME).o


# Paths
KERNEL_DIR := $(HOME)/repos/kernels/raspberry_pi
MODULE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
APP_SRC := $(APP_NAME).c


# Target architecture and compiler settings
KERNEL_ARCHITECTURE := arm  # Target architecture (ARM)
COMPILER := clang
LINKER := ld.lld



# Clang flags for the kernel module
TARGET_TOOLCHAIN := arm-linux-gnueabihf  	# Target toolchain prefix
CPU_ARCH_FLAGS := -march=armv8-a  				# Specify ARMv8-A architecture

# Flags for kernel module compilation
CLANG_FLAGS := --target=$(TARGET_TOOLCHAIN) $(CPU_ARCH_FLAGS) \
	-fno-pic \
	-Wall -Wextra \
	-Wno-unused-parameter -Wno-sign-compare

# Clang flags for the application
APP_CFLAGS := --target=$(TARGET_TOOLCHAIN) $(CPU_ARCH_FLAGS) \
  -Wall -Wextra



# Default target: build both the application and kernel module
default: build deploy

# Build both the application and kernel module
build: $(APP_NAME).out
	$(MAKE) -C $(KERNEL_DIR) M=$(MODULE_DIR) modules ARCH=$(KERNEL_ARCHITECTURE) \
	CC=$(COMPILER) LD=$(LINKER) KBUILD_CFLAGS="$(CLANG_FLAGS)"

# Deploy built artifacts
deploy:
	cp $(MODULE_NAME).ko /nfs/drivers  # Copy the kernel module
	cp $(APP_NAME).out /nfs/drivers/$(APP_NAME)  							# Copy the app without extension

# Build the application
$(APP_NAME).out:
	$(COMPILER) $(APP_CFLAGS) $(APP_SRC) -o $(APP_NAME).out  	# Generate app with .out extension

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
	rm -rf $(APP_NAME).out        # Remove the application binary with .out extension

