
#!/usr/bin/env fish
# 📅 Written at 2025-01-01 20:06:45

function set_raspberry_pi_kernel_bitness
    # Prompt user to select OS bit mode
    echo "Select OS bit mode:"
    echo "1. 32-bit"
    echo "2. 64-bit"
    read -l user_choice

    # Set the desired line based on user input
    if test $user_choice = 1
        set arm_64bit_line "arm_64bit=0"
    else if test $user_choice = 2
        set arm_64bit_line "arm_64bit=1"
    else
        echo "Invalid choice. Exiting."
        return 1
    end

    # Define the config file path
    set config_file "/boot/firmware/config.txt"
    if not test -f $config_file
        echo "Error: Config file not found at $config_file"
        return 1
    end

    # Temporary file
    set tmp_file (mktemp)

    # Process the file with gawk
    gawk -v arm_64bit_line="$arm_64bit_line" '
    BEGIN {
        found_arm_64bit = 0
        in_all_section = 0
    }
    # Detect [all] section
    $0 ~ /^\[all\]$/ {
        in_all_section = 1
        print
        next
    }
    # Process lines within [all] section
    in_all_section && $0 ~ /^arm_64bit=/ {
        print arm_64bit_line
        found_arm_64bit = 1
        in_all_section = 0  # Stop looking further
        next
    }
    # End of [all] section
    in_all_section && $0 ~ /^\[/ {
        in_all_section = 0
    }
    {
        print
    }
    END {
        # Append arm_64bit if it was not found in [all]
        if (in_all_section && !found_arm_64bit) {
            print arm_64bit_line
        } else if (!found_arm_64bit) {
            print "[all]"
            print arm_64bit_line
        }
    }' $config_file >$tmp_file

    ## Overwrite the original file
    #💡 Get the ownership and permissions of the original file
    set file_owner (stat -c '%u' $config_file) # Owner user ID
    set file_group (stat -c '%g' $config_file) # Owner group ID
    set file_mode (stat -c '%a' $config_file) # Permissions in octal

    # Apply the same ownership and permissions to the temporary file
    sudo chown $file_owner:$file_group $tmp_file
    sudo chmod $file_mode $tmp_file

    # Overwrite the original file
    sudo mv $tmp_file $config_file
    if test $status -eq 0
        echo "Successfully updated $config_file with $arm_64bit_line"
    else
        echo "Error updating $config_file"
    end
end

# Run the function
set_raspberry_pi_kernel_bitness
