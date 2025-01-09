#!/usr/bin/env fish
# 🐟 Fish Shell initialization
set -Ux FISH_CONFIG_PATH "$HOME/.config/fish/config.fish"
set -Ux FISH_COMPLETIONS_DIR "$HOME/.config/fish/completions"

touch $FISH_CONFIG_PATH
set -U fish_greeting

# Fisher 🔪 Installation ; https://github.com/jorgebucaran/fisher
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

fisher install jorgebucaran/replay.fish
fisher install berk-karaal/loadenv.fish




# 🥞 To find available packages, see ROS Index or use: https://index.ros.org/packages/page/1/time/#noetic
#   apt search ros-noetic

echo '

function rosed
    nano (rospack find $argv[1])/$argv[2]
end

function roscat
    if test (count $argv) -lt 2
        echo "Usage: roscat <package_name> <file_name>"
        return 1
    end
    cat (rospack find $argv[1])/$argv[2]
end

function roscp
    if test (count $argv) -lt 3
        echo "Usage: roscp <package_name> <source_file> <destination>"
        return 1
    end
    cp (rospack find $argv[1])/$argv[2] $argv[3]
end

function rosd
    cd /opt/ros/noetic
end

function rospd
    cd -
end

function roscd
    # Ensure an argument is provided
    if test (count $argv) -eq 0
        echo "Usage: roscd <package_name/subpath>"
        return 1
    end

    # Split the input into package name and optional subpath
    set parts (string split "/" $argv[1])
    set package_name $parts[1]
    set subpath (string join "/" $parts[2..-1])

    # Get the package path
    set package_path (rospack find $package_name)

    # Check if the package exists
    if test -z "$package_path"
        echo "Error: package \'$package_name\' not found"
        return 1
    end

    # Construct the full path
    if test -n "$subpath"
        set full_path "$package_path/$subpath"
    else
        set full_path "$package_path"
    end

    # Check if the full path is a valid directory
    if test -d "$full_path"
        cd "$full_path"
    else
        echo "Error: \'$full_path\' is not a valid directory"
        return 1
    end
end


function rosls
    # Ensure an argument is provided
    if test (count $argv) -eq 0
        echo "Usage: rosls <package_name/subpath>"
        return 1
    end

    # Split the input into package name and optional subpath
    set parts (string split "/" $argv[1])
    set package_name $parts[1]
    set subpath (string join "/" $parts[2..-1])

    # Get the package path
    set package_path (rospack find $package_name)

    # Check if the package exists
    if test -z "$package_path"
        echo "Error: package \'$package_name\' not found"
        return 1
    end

    # Construct the full path
    if test -n "$subpath"
        set full_path "$package_path/$subpath"
    else
        set full_path "$package_path"
    end

    # Check if the full path is a valid directory
    if test -d "$full_path"
        ls "$full_path"
    else
        echo "Error: \'$full_path\' is not a valid directory"
        return 1
    end
end


replay source /opt/ros/noetic/setup.bash
replay source /workspace/devel/setup.bash

set -x TURTLEBOT3_MODEL buger

set -x ROS_MASTER_URI http://10.10.14.19:11311
set -x ROS_HOSTNAME 10.10.14.19

' | tee $FISH_CONFIG_PATH >/dev/null



# https://fishshell.com/docs/current/completions.html
# https://stackoverflow.com/questions/41161234/alias-with-whitespace-in-fish-shell

echo '## Fish Shell completions for roscd
# Clear all existing completions for roscd
complete -c roscd -f

# Enable custom completion for ROS packages
complete -c roscd -a "(rospack list | awk \'{print $1}\')" -d "ROS packages"
' | tee $FISH_COMPLETIONS_DIR/roscd.fish >/dev/null



echo '## Fish Shell completions for rosls
# Clear all existing completions for rosls
complete -c rosls -f

# Enable custom completion for ROS packages
complete -c rosls -a "(rospack list | awk \'{print \$1}\')" -d "ROS packages"
' | tee $FISH_COMPLETIONS_DIR/rosls.fish >/dev/null







source $FISH_CONFIG_PATH
