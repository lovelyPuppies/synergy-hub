# Application name
APP_NAME := kernel_timer_app

# Paths
APP_DIR := src
BUILD_DIR := ../build/app
APP_INC := -Iinclude -I../include

# Compiler settings
COMPILER := clang
TARGET_TOOLCHAIN := aarch64-linux-gnu
CPU_ARCH_FLAGS := -march=armv8-a
APP_CFLAGS := --target=$(TARGET_TOOLCHAIN) $(CPU_ARCH_FLAGS) -Wall -Wextra $(APP_INC)

# Default target
default: build

# Build the application
build:
	@mkdir -p $(BUILD_DIR)
	$(COMPILER) $(APP_CFLAGS) $(APP_DIR)/$(APP_NAME).c -o $(BUILD_DIR)/$(APP_NAME).out

# Clean artifacts
clean:
	rm -rf $(BUILD_DIR)
