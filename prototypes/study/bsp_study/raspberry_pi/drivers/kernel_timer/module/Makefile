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

## Common include directory
COMMON_INCLUDE_DIR := $(COMMON_INCLUDE_DIR)



### ❔ Module specific settings
## Module specific settings
SRC_NAME := src
SRC_DIR := $(PWD)/src
KERNEL_DIR := $(HOME)/repos/kernels/raspberry-pi
# Include directories and compiler flags
INCLUDE_DIRS := -I$(COMMON_INCLUDE_DIR) -Iinclude
CFLAGS := -fno-pic -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare $(INCLUDE_DIRS)

# Kernel build module variables
CLANG_FLAGS := --target=$(TARGET_TOOLCHAIN) $(CPU_ARCH_FLAGS) $(CFLAGS)

# Add source files to the module






# Add source files to the module
obj-m := $(MODULE_NAME).o
# ❓
# $(MODULE_NAME)-y := $(patsubst $(SRC_DIR)/%.c, %.o, $(wildcard $(SRC_DIR)/*.c))
$(MODULE_NAME)-y := $(patsubst $(SRC_DIR)/%.c, src/%.o, $(wildcard $(SRC_DIR)/*.c))




# Default target
default: build

# Build kernel module
build:
	@echo $(SRC_DIR)
	@echo $(SRC_DIR)
	@echo $(SRC_FILES)
	@echo $(SRC_FILES)
	@echo $(SRC_FILES2)
	@echo $(SRC_FILES2)
	$(MAKE) -C $(KERNEL_DIR) M=$(PWD) modules ARCH=$(KERNEL_ARCHITECTURE) CC=$(COMPILER) LD=$(LINKER) KBUILD_CFLAGS="$(CLANG_FLAGS)"


# Clean build artifacts
clean:
	$(MAKE) -C $(KERNEL_DIR) M=$(PWD) O=$(BUILD_DIR) clean

#❗ https://stackoverflow.com/questions/2483182/recursive-wildcards-in-gnu-make
## 커널 모듈 Makefile에 일반 애플리케이션과 비슷한 구조를 일부 활용하는 것은 가능합니다. 다만, 커널 모듈 빌드는 커널 빌드 시스템 (KBUILD)에 의해 관리되므로 obj-m 방식으로 동작해야 하며, 객체 파일(OBJS)을 수동으로 관리하는 방식은 기본적으로 커널 모듈 빌드의 규칙과 맞지 않습니다.


# # Kernel module name
# obj-m := kernel_timer_dev.o

# # Add include directories
# EXTRA_CFLAGS += -I$(M)/include -I$(M)/../include

# # Source file path
# kernel_timer_dev-objs := src/kernel_timer_dev.o

# # Default target
# default: build

# # Build the kernel module
# build:
# 	$(MAKE) -C $(KERNEL_DIR) M=$(PWD) O=$(BUILD_DIR) modules

# # Clean artifacts
# clean:
# 	$(MAKE) -C $(KERNEL_DIR) M=$(PWD) O=$(BUILD_DIR) clean



