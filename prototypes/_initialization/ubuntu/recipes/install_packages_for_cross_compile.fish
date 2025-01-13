#!/usr/bin/env fish
# Written at 📅 2025-01-13 18:37:33
# Handle SIGINT (Ctrl+C) to exit the script and terminate any child processes
function on_interrupt
    echo -e "\nScript interrupted. Exiting..."
    # Kill all child processes in the same process group
    kill -- -$fish_pid
    exit 1
end
trap on_interrupt SIGINT


echo "🌳  Please choose the target architecture for cross-compilation tools."
echo "  Options: arm64 or arm32"
while true
    echo "Enter the target architecture (arm64/arm32):"
    read --local architecture
    switch $architecture
        case arm64
            echo "Installing AARCH64 (arm64) cross-compilation tools..."
            sudo apt install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu
            : '
            These tools install the cross-compilation toolchain for 64-bit ARM (AArch64) targets.
              - Adds binaries like `aarch64-linux-gnu-gcc`, `aarch64-linux-gnu-g++`, and related tools.
              - These binaries allow you to compile and link software for 64-bit ARM platforms.
              - 💡 Note: AArch64 does not have separate hard-float or soft-float variants because hardware floating-point is always supported.
            To verify the installation:
              - Type 🧮 `aarch64-linux-gnu-*` and press the Tab key in Fish shell.
            '
            echo "AARCH64 (arm64) cross-compilation tools installed successfully!"
            break

        case arm32
            echo "Installing ARM (arm32) cross-compilation tools..."
            sudo apt install gcc-arm-linux-gnueabi g++-arm-linux-gnueabi \
                gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf

            : '
            These tools install the cross-compilation toolchain for 32-bit ARM targets.
              - Adds binaries like `arm-linux-gnueabi-gcc`, `arm-linux-gnueabi-g++`, and related tools.
              - Supports soft-float ABI (via `arm-linux-gnueabi-*` binaries).
              - For hard-float ABI, consider using the `arm-linux-gnueabihf-*` binaries.
            To verify the installation:
              - Type 🧮 `arm-linux-gnueabi-*` or 🧮 `arm-linux-gnueabihf-*` and press the Tab key in Fish shell.
            '
            echo "ARM (arm32) cross-compilation tools installed successfully!"
            break

        case '*'
            echo "Invalid input. Please enter 'arm64' or 'arm32'."
    end
end
