# Common names
APP_NAME := kernel_timer_app
MODULE_NAME := kernel_timer_dev

# Paths
BUILD_DIR := $(PWD)/build
DEPLOY_DIR := /nfs/drivers

APP_DIR_NAME := app
APP_DIR := $(PWD)/$(APP_DIR_NAME)
APP_BUILD_DIR := $(BUILD_DIR)/$(APP_DIR_NAME)
MODULE_DIR_NAME := module
MODULE_DIR := $(PWD)/$(MODULE_DIR_NAME)
MODULE_BUILD_DIR := $(BUILD_DIR)/$(MODULE_DIR_NAME)


### ❔ Common Configuration: Toolchain, compiler, directories, and module settings
## Toolchain and architecture settings
# Define the cross-compiler toolchain for ARM 64-bit architecture
TARGET_TOOLCHAIN := aarch64-linux-gnu
# Set the compiler flags for optimizing code for ARMv8-A architecture
CPU_ARCH_FLAGS := -march=armv8-a
# Specify the target architecture for the kernel build (ARM 64-bit)
KERNEL_ARCHITECTURE := arm64

## Compiler and linker settings
COMPILER := clang
LINKER := ld.lld

## Common include directory
COMMON_INCLUDE_DIR := $(PWD)/include






### ❔ Targets and Rules: Define build steps and dependencies
# Default target: build everything
default: build deploy

# Build both the application and kernel module
build: build-app build-module

# Delegate to app Makefile
build-app:
	@mkdir -p $(APP_BUILD_DIR)
	$(MAKE) -C $(APP_DIR) APP_NAME=$(APP_NAME) BUILD_DIR=$(APP_BUILD_DIR) COMPILER=$(COMPILER) LINKER=$(LINKER) TARGET_TOOLCHAIN=$(TARGET_TOOLCHAIN) CPU_ARCH_FLAGS=$(CPU_ARCH_FLAGS) KERNEL_ARCHITECTURE=arm64 COMMON_INCLUDE_DIR=$(COMMON_INCLUDE_DIR)

# Delegate to module Makefile
build-module:
	$(MAKE) -C $(MODULE_DIR) MODULE_NAME=$(MODULE_NAME) BUILD_DIR=$(MODULE_BUILD_DIR) \
	\
	TARGET_TOOLCHAIN=$(TARGET_TOOLCHAIN) \
	CPU_ARCH_FLAGS=$(CPU_ARCH_FLAGS) \
	KERNEL_ARCHITECTURE=$(KERNEL_ARCHITECTURE) \
	\
	COMPILER=$(COMPILER) \
	LINKER=$(LINKER) \
	\
	COMMON_INCLUDE_DIR=$(COMMON_INCLUDE_DIR)



# Deploy artifacts
deploy: deploy-app deploy-module

deploy-app:
	@mkdir -p $(DEPLOY_DIR)/$(APP_DIR_NAME)
	cp $(BUILD_DIR)/$(APP_DIR_NAME)/$(APP_NAME).out $(DEPLOY_DIR)/$(APP_DIR_NAME)/

deploy-module:
	@mkdir -p $(DEPLOY_DIR)/$(MODULE_DIR_NAME)
	cp $(BUILD_DIR)/$(MODULE_DIR_NAME)/$(MODULE_NAME).ko $(DEPLOY_DIR)/$(MODULE_DIR_NAME)/



# Clean build artifacts
clean: clean-app clean-module

clean-app:
	$(MAKE) -C $(APP_DIR_NAME) clean BUILD_DIR=$(BUILD_DIR)/app

clean-module:
	$(MAKE) -C $(MODULE_DIR_NAME) clean BUILD_DIR=$(BUILD_DIR)/$(MODULE_DIR_NAME)



# # Application and kernel module names
# APP_NAME := kernel_timer_app
# MODULE_NAME := kernel_timer_dev

# # Paths
# KERNEL_DIR := $(HOME)/repos/kernels/raspberry-pi
# # Updated to point to app directory
# APP_DIR := app
# # Use absolute path for the module directory
# MODULE_DIR := $(PWD)/module
# APP_INC := -Iapp/include -Iinclude
# MODULE_INC := -Imodule/include -Iinclude
# BUILD_DIR := build
# DEPLOY_DIR := /nfs/drivers

# # Target architecture and compiler settings
# COMPILER := clang
# LINKER := ld.lld
# TARGET_TOOLCHAIN := aarch64-linux-gnu
# CPU_ARCH_FLAGS := -march=armv8-a

# # Flags for kernel module compilation
# CLANG_FLAGS := --target=$(TARGET_TOOLCHAIN) $(CPU_ARCH_FLAGS) \
#     -fno-pic \
#     -Wall -Wextra \
#     -Wno-unused-parameter -Wno-sign-compare $(MODULE_INC)

# # Flags for application compilation
# APP_CFLAGS := --target=$(TARGET_TOOLCHAIN) $(CPU_ARCH_FLAGS) \
#     -Wall -Wextra $(APP_INC)

# # Default target: build everything
# default: build deploy

# # Build both the application and kernel module
# build: build-app build-module

# #🤝 Build the application (Delegate application build to the Makefile in the app folder)
# build-app:
# 	$(MAKE) -C $(APP_DIR)

# # Build the kernel module
# build-module:
# 	$(MAKE) -C $(KERNEL_DIR) M=$(MODULE_DIR) modules ARCH=arm64 \
# 	    CC=$(COMPILER) LD=$(LINKER) KBUILD_CFLAGS="$(CLANG_FLAGS)"

# # Deploy artifacts
# deploy: deploy-app deploy-module

# # Deploy the application
# deploy-app: build-app
# 	@mkdir -p $(DEPLOY_DIR)/app
# 	cp $(BUILD_DIR)/app/$(APP_NAME).out $(DEPLOY_DIR)/app/

# # Deploy the kernel module
# deploy-module: build-module
# 	@mkdir -p $(DEPLOY_DIR)/module
# 	cp $(MODULE_DIR)/*.ko $(DEPLOY_DIR)/module/$(MODULE_NAME).ko


# # Clean build artifacts
# clean: clean-app clean-module

# #🤝 Clean only app (Delegate application build to the Makefile in the app folder)
# clean-app:
# 	$(MAKE) -C $(APP_DIR) clean

# # Clean only module
# clean-module:
# 	$(MAKE) -C $(KERNEL_DIR) M=$(MODULE_DIR) clean
# 	find "$(MODULE_DIR)/src" -type f \( -name '*.o' -o -name '*.o.cmd' \) -delete
