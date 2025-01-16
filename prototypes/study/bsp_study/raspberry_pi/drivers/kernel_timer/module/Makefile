# ☑️ Note that $(PWD) always indicates the directory of the first Makefile invoked, even if new Makefiles are called. 📅 2025-01-17 01:25:33
#	📝 Note that $(dir ...) always retains the trailing "/" in the returned directory path.
PWD := $(basename $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))


# Module-specific variables
MODULE_NAME := $(MODULE_NAME)
SRC_DIR := $(PWD)/src
BUILD_DIR := $(BUILD_DIR)
COMPILER := $(COMPILER)
LINKER := $(LINKER)
COMMON_INCLUDE_DIR := $(COMMON_INCLUDE_DIR)

# Kernel build settings
KERNEL_DIR := $(HOME)/repos/kernels/raspberry-pi

# Include directories and compiler flags
INCLUDE_DIRS := -I$(COMMON_INCLUDE_DIR) -Iinclude
CFLAGS := -fno-pic -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare $(INCLUDE_DIRS)

# Kernel build module variables
KERNEL_ARCHITECTURE := arm64
CLANG_FLAGS := --target=$(TARGET_TOOLCHAIN) $(CPU_ARCH_FLAGS) $(CFLAGS)

# Add source files to the module
obj-m := $(MODULE_NAME).o
# ❓
# $(MODULE_NAME)-y := $(patsubst $(SRC_DIR)/%.c, %.o, $(wildcard $(SRC_DIR)/*.c))
$(MODULE_NAME)-y := $(patsubst $(SRC_DIR)/%.c, src/%.o, $(wildcard $(SRC_DIR)/*.c))


# Default target
default: build

# Build kernel module
build:
	$(MAKE) -C $(KERNEL_DIR) M=$(PWD) modules ARCH=$(KERNEL_ARCHITECTURE) CC=$(COMPILER) LD=$(LINKER) KBUILD_CFLAGS="$(CLANG_FLAGS)"


# Clean build artifacts
clean:
	$(MAKE) -C $(KERNEL_DIR) M=$(PWD) O=$(BUILD_DIR) clean

#⚠️ build 플래그에  O=$(BUILD_DIR) ? 이걸 넣으면 KERNEL_DIR 에서 상대경로로 BUILD_DIR 을 찾아버린다. .
#⚠️  M=$(PWD)$(SRC_DIR) 이 기준으로 Makefile 을 찾는다..
## 커널 모듈 Makefile에 일반 애플리케이션과 비슷한 구조를 일부 활용하는 것은 가능합니다. 다만, 커널 모듈 빌드는 커널 빌드 시스템 (KBUILD)에 의해 관리되므로 obj-m 방식으로 동작해야 하며, 객체 파일(OBJS)을 수동으로 관리하는 방식은 기본적으로 커널 모듈 빌드의 규칙과 맞지 않습니다.
## ❗ !!ㅣMakefile 에도 값을 전달해도 유효하도록.. 변수를 처음부터 절대경로를 지정.. $(PWD)
# 	modinfo $(MODULE_NAME).ko


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



