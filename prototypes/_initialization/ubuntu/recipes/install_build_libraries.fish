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
            echo "AARCH64 (arm64) cross-compilation tools installed successfully!"
            break

        case arm32
            echo "Installing ARM (arm32) cross-compilation tools..."
            sudo apt install gcc-arm-linux-gnueabi g++-arm-linux-gnueabi
            echo "ARM (arm32) cross-compilation tools installed successfully!"
            break

        case '*'
            echo "Invalid input. Please enter 'arm64' or 'arm32'."
    end
end
