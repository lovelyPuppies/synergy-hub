# Application name
APP_NAME := kernel_timer_app

# Paths
SRC_DIR := src
BUILD_DIR := ../build/app
INCLUDE_DIRS := -Iinclude -I../include

# Compiler settings
COMPILER := clang
TARGET_TOOLCHAIN := aarch64-linux-gnu
CPU_ARCH_FLAGS := -march=armv8-a
CFLAGS := --target=$(TARGET_TOOLCHAIN) $(CPU_ARCH_FLAGS) -Wall -Wextra $(INCLUDE_DIRS)

# Source files
SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SRCS))

# Default target
default: $(BUILD_DIR)/$(APP_NAME).out

## Build the application
# The target '$(BUILD_DIR)/$(APP_NAME).out' depends on all object files in 'OBJS'.
# 	🚣 If any object file changes, this rule is triggered to rebuild the application.
$(BUILD_DIR)/$(APP_NAME).out: $(OBJS)
	# Create the build directory if it doesn't already exist.
	@mkdir -p $(BUILD_DIR)
	# Use the compiler to link all object files in 'OBJS' into the final application executable.
	# 	'$@' refers to the target file (application output), and '$<' would refer to the first prerequisite if needed.
	$(COMPILER) $(CFLAGS) -o $@ $(OBJS)

## Compile source files to object files
# This is a pattern rule for converting individual .c files to .o files.
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	# Ensure the build directory exists before generating the .o file.
	@mkdir -p $(BUILD_DIR)
	# 	Compile the source file ('$<') into an object file ('$@') using the compiler and flags.
	$(COMPILER) $(CFLAGS) -c -o $@ $<

## Clean artifacts
clean:
	rm -rf $(BUILD_DIR)














# # Application-specific variables
# APP_NAME := $(APP_NAME)
# SRC_DIR := src
# BUILD_DIR := $(BUILD_DIR)
# INCLUDE_DIRS := -Iinclude -I../include
# COMPILER := $(COMPILER)
# LINKER := $(LINKER)
# CFLAGS := $(COMMON_CFLAGS) $(INCLUDE_DIRS)

# # Source files and object files
# SRCS := $(wildcard $(SRC_DIR)/*.c)
# OBJS := $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SRCS))

# # Default target
# default: $(BUILD_DIR)/$(APP_NAME).out

# ## Build the application
# # The target '$(BUILD_DIR)/$(APP_NAME).out' depends on all object files in 'OBJS'.
# # 	🚣 If any object file changes, this rule is triggered to rebuild the application.
# # Rule:
# #		Create the build directory if it doesn't already exist.
# # 	Use the compiler to link all object files in 'OBJS' into the final application executable.
# # 		'$@' refers to the target file (application output), and '$<' would refer to the first prerequisite if needed.
# $(BUILD_DIR)/$(APP_NAME).out: $(OBJS)
# 	@mkdir -p $(BUILD_DIR)
# 	$(COMPILER) $(CFLAGS) -o $@ $(OBJS)

# ## Compile source files to object files
# # This is a pattern rule for converting individual .c files to .o files.
# # Rule:
# #		Ensure the build directory exists before generating the .o file.
# # 		Compile the source file ('$<') into an object file ('$@') using the compiler and flags.
# $(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
# 	@mkdir -p $(BUILD_DIR)
# 	$(COMPILER) $(CFLAGS) -c -o $@ $<


# # Clean
# clean:
# 	rm -rf $(BUILD_DIR)
