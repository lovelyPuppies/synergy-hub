# Application and kernel module names
APP_NAME := kernel_timer_app
MODULE_NAME := kernel_timer_dev

# Paths
KERNEL_DIR := $(HOME)/repos/kernels/raspberry-pi
# Updated to point to app directory
APP_DIR := app
# Use absolute path for the module directory
MODULE_DIR := $(PWD)/module
APP_INC := -Iapp/include -Iinclude
MODULE_INC := -Imodule/include -Iinclude
BUILD_DIR := build
DEPLOY_DIR := /nfs/drivers

# Target architecture and compiler settings
COMPILER := clang
LINKER := ld.lld
TARGET_TOOLCHAIN := aarch64-linux-gnu
CPU_ARCH_FLAGS := -march=armv8-a

# Flags for kernel module compilation
CLANG_FLAGS := --target=$(TARGET_TOOLCHAIN) $(CPU_ARCH_FLAGS) \
    -fno-pic \
    -Wall -Wextra \
    -Wno-unused-parameter -Wno-sign-compare $(MODULE_INC)

# Flags for application compilation
APP_CFLAGS := --target=$(TARGET_TOOLCHAIN) $(CPU_ARCH_FLAGS) \
    -Wall -Wextra $(APP_INC)

# Default target: build everything
default: build deploy

# Build both the application and kernel module
build: build-app build-module

#🤝 Build the application (Delegate application build to the Makefile in the app folder)
build-app:
	$(MAKE) -C $(APP_DIR)

# Build the kernel module
build-module:
	$(MAKE) -C $(KERNEL_DIR) M=$(MODULE_DIR) modules ARCH=arm64 \
	    CC=$(COMPILER) LD=$(LINKER) KBUILD_CFLAGS="$(CLANG_FLAGS)"

# Deploy artifacts
deploy: deploy-app deploy-module

# Deploy the application
deploy-app: build-app
	@mkdir -p $(DEPLOY_DIR)/app
	cp $(BUILD_DIR)/app/$(APP_NAME).out $(DEPLOY_DIR)/app/

# Deploy the kernel module
deploy-module: build-module
	@mkdir -p $(DEPLOY_DIR)/module
	cp $(MODULE_DIR)/*.ko $(DEPLOY_DIR)/module/$(MODULE_NAME).ko


# Clean build artifacts
clean: clean-app clean-module

#🤝 Clean only app (Delegate application build to the Makefile in the app folder)
clean-app:
	$(MAKE) -C $(APP_DIR) clean

# Clean only module
clean-module:
	$(MAKE) -C $(KERNEL_DIR) M=$(MODULE_DIR) clean
	find "$(MODULE_DIR)/src" -type f \( -name '*.o' -o -name '*.o.cmd' \) -delete
