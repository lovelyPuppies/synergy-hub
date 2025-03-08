#!/usr/bin/env fish
# 📅 Written at 2024-12-29 06:21:53
function on_interrupt
    echo -e "\nScript interrupted. Exiting..."
    # Kill all child processes in the same process group
    kill -- -$fish_pid
    exit 1
end
trap on_interrupt SIGINT


sudo -v
# Prompt for sudo password to ensure the script has necessary privileges

# Function definition
function setup_xauthority
    : '
        🪱 SDDM (Simple Desktop Display Manager) is the default display manager used in KDE-based distributions like Kubuntu.
        It manages graphical logins and sessions.
        
        In this function, SDDM is responsible for launching the Xorg server, which creates the Xauthority file required for graphical authentication.
        This script locates and copies that file.       
    '
    # Use pgrep to find the Xorg process and extract the path to the Xauthority file
    #   🛍️ e.g. xauth_path: /run/sddm/xauth_kWfguu
    set xauth_path (pgrep -a Xorg | awk -F '-auth ' '{print $2}' | awk '{print $1}')

    # If the path is empty, print an error message and exit with a failure code
    if test -z "$xauth_path"
        echo "Error: Unable to find Xauthority file path. Is the X server running?"
        return 1
    end

    # Print the found path for debugging purposes
    echo "Found Xauthority path: $xauth_path"

    # Check if the file exists at the extracted path
    # If it exists, copy it to the user's home directory and update ownership
    if test -e "$xauth_path"
        sudo cp $xauth_path ~/.Xauthority
        sudo chown $USER:$USER ~/.Xauthority
        echo "Xauthority file copied and ownership updated."
    else
        # Print an error message if the file does not exist
        echo "Error: Xauthority file not found at $xauth_path"
        return 1
    end
end

# Execute the setup_xauthority function
setup_xauthority
