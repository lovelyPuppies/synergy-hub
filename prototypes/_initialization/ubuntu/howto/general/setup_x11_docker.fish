#!/usr/bin/env fish
# 📅 Written at 2025-01-07 20:37:06
function on_interrupt
    echo -e "\nScript interrupted. Exiting..."
    # Kill all child processes in the same process group
    kill -- -$fish_pid
    exit 1
end
trap on_interrupt SIGINT

# Ensures x11-utils is installed and sets up X11 access for Docker.

# Check if x11-utils is installed
function check_x11_utils
    if dpkg -s x11-utils >/dev/null 2>&1
        echo "x11-utils is already installed."
    else
        echo "x11-utils is not installed. Installing..."
        sudo apt update && sudo apt install -y x11-utils
        echo "x11-utils installation complete."
    end
end

# Allow X11 access for Docker
function allow_x11_for_docker
    echo "Allowing X11 access for Docker..."
    xhost +local:docker
    echo "X11 access granted for Docker."
end

# Main script execution
check_x11_utils
allow_x11_for_docker
