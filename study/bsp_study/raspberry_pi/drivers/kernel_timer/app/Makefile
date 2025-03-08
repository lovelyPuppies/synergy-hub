PWD := $(shell pwd)


### ❔ Configuration: Module Name, Build Directory 🔗 from Caller Makefile
APP_NAME := $(APP_NAME)
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



### ❔ Application-specific settings
# Application-specific variables
SRC_NAME := src
SRC_DIR := $(PWD)/$(SRC_NAME)

#⚙️ Include directories and compiler flags
INCLUDE_DIRS := $(COMMON_INCLUDE_FLAGS) -Iinclude
CFLAGS := -Wall -Wextra $(INCLUDE_DIRS)

CLANG_FLAGS := --target=$(TARGET_TOOLCHAIN) $(CPU_ARCH_FLAGS) $(CFLAGS) -fuse-ld=$(LINKER)


# Source files and object files
SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SRCS))







### ❔ Targets and Rules: Define build steps and dependencies
# Default target
default: $(BUILD_DIR)/$(APP_NAME).out

## Build the application
# The target '$(BUILD_DIR)/$(APP_NAME).out' depends on all object files in 'OBJS'.
# 	🚣 If any object file changes, this rule is triggered to rebuild the application.
# Rule:
#		Create the build directory if it doesn't already exist.
# 	Use the compiler to link all object files in 'OBJS' into the final application executable.
# 		'$@' refers to the target file (application output), and '$<' would refer to the first prerequisite if needed.
$(BUILD_DIR)/$(APP_NAME).out: $(OBJS)
	$(COMPILER) $(CLANG_FLAGS) -o $@ $(OBJS)

## Compile source files to object files
# This is a pattern rule for converting individual .c files to .o files.
# Rule:
#		Ensure the build directory exists before generating the .o file.
# 		Compile the source file ('$<') into an object file ('$@') using the compiler and flags.
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(COMPILER) $(CLANG_FLAGS) -c -o $@ $<


# Clean
clean:
	rm -rf $(BUILD_DIR)




