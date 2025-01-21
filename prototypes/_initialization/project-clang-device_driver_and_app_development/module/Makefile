# ☑️ Note that default $(PWD) value always indicates the directory of the first Makefile invoked, even if new Makefiles are called. 📅 2025-01-17 10:31:57
#		Also, `(dir $(realpath $(lastword $(MAKEFILE_LIST))))` always retains the trailing "/" in the returned directory path, and it cannot be removed.
PWD := $(shell pwd)

### ❔ Configuration: Module Name, Build Directory 🔗 from Caller Makefile
MODULE_NAME := $(MODULE_NAME)
BUILD_DIR := $(BUILD_DIR)

### ❔ Common Configuration: Toolchain, compiler, directories, and module settings 🔗 from Caller Makefile
## Toolchain and architecture settings
# Define the cross-compiler toolchain for ARM 64-bit architecture
TARGET_TOOLCHAIN := $(TARGET_TOOLCHAIN)
# Set the compiler flags for optimizing code for ARMv8-A architecture
CPU_ARCH_FLAGS := $(CPU_ARCH_FLAGS)
# Specify the target architecture for the kernel build (ARM 64-bit)
KERNEL_ARCHITECTURE := $(CPU_ARCH_FLAGS)

## Compiler and linker settings
COMPILER := $(COMPILER)
LINKER := $(LINKER)

## Common include flags
COMMON_INCLUDE_FLAGS := $(COMMON_INCLUDE_FLAGS)



### ❔ Module-specific settings
## Module specific settings
SRC_NAME := src
SRC_DIR := $(PWD)/$(SRC_NAME)
KERNEL_DIR := $(HOME)/repos/kernels/raspberry_pi
#⚙️ Include directories and compiler flags
INCLUDE_DIRS := $(COMMON_INCLUDE_FLAGS) -Iinclude
CFLAGS := -fno-pic -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare $(INCLUDE_DIRS)

# Kernel build module variables
CLANG_FLAGS := --target=$(TARGET_TOOLCHAIN) $(CPU_ARCH_FLAGS) $(CFLAGS)


## ❗ Kernel module builds are managed by the kernel build system (KBUILD) and must operate using the obj-m system, unlike app builds.
obj-m := $(MODULE_NAME).o
#⚙️ Add source files to the module
$(MODULE_NAME)-y := $(SRC_NAME)/kernel_timer_dev.o



### ❔ Targets and Rules: Define build steps and dependencies
# Default target
default: build

# Build kernel module
build:
	$(MAKE) -C $(KERNEL_DIR) M=$(PWD) modules ARCH=$(KERNEL_ARCHITECTURE) CC=$(COMPILER) LD=$(LINKER) KBUILD_CFLAGS="$(CLANG_FLAGS)"


# Clean build artifacts
clean:
	$(MAKE) -C $(KERNEL_DIR) M=$(PWD) O=$(BUILD_DIR) clean

