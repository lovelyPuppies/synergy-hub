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
MODULE_BUILD_DIR := $(MODULE_DIR)


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
LINKER := lld

## Common include directory
COMMON_INCLUDE_ROOT_DIR := $(PWD)/include
FOUND_INCLUDE_DIRS := $(shell find $(COMMON_INCLUDE_ROOT_DIR) -type d)
COMMON_INCLUDE_FLAGS := $(addprefix -I, $(FOUND_INCLUDE_DIRS))






### ❔ Targets and Rules: Define build steps and dependencies
# Default target: build everything
default: build deploy

# Build both the application and kernel module
build: build-app build-module

#🤝 Delegate to app Makefile
build-app:
	@mkdir -p $(APP_BUILD_DIR)
	$(MAKE) -C $(APP_DIR) APP_NAME=$(APP_NAME) BUILD_DIR=$(APP_BUILD_DIR) \
	\
	TARGET_TOOLCHAIN=$(TARGET_TOOLCHAIN) \
	CPU_ARCH_FLAGS=$(CPU_ARCH_FLAGS) \
	KERNEL_ARCHITECTURE=$(KERNEL_ARCHITECTURE) \
	\
	COMPILER=$(COMPILER) \
	LINKER=$(LINKER) \
	\
	COMMON_INCLUDE_FLAGS=$(COMMON_INCLUDE_FLAGS)


#🤝 Delegate to module Makefile
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
	COMMON_INCLUDE_FLAGS=$(COMMON_INCLUDE_FLAGS)



# Deploy artifacts
deploy: deploy-app deploy-module

deploy-app:
	@mkdir -p $(DEPLOY_DIR)/$(APP_DIR_NAME)
	cp $(APP_BUILD_DIR)/$(APP_NAME).out $(DEPLOY_DIR)/$(APP_DIR_NAME)/$(APP_NAME)

deploy-module:
	@mkdir -p $(DEPLOY_DIR)/$(MODULE_DIR_NAME)
	cp $(MODULE_BUILD_DIR)/$(MODULE_NAME).ko $(DEPLOY_DIR)/$(MODULE_DIR_NAME)/



# Clean build artifacts
clean: clean-app clean-module

clean-app:
	$(MAKE) -C $(APP_DIR_NAME) clean BUILD_DIR=$(APP_BUILD_DIR)

clean-module:
	$(MAKE) -C $(MODULE_DIR_NAME) clean BUILD_DIR=$(MODULE_BUILD_DIR)

