#!/usr/bin/env fish
## 🐟 Fish Shell initialization
set -Ux FISH_CONFIG_PATH "$HOME/.config/fish/config.fish"
set -Ux FISH_CONFIG_DIR "$HOME/.config/fish/conf.d"

touch $FISH_CONFIG_PATH
set -U fish_greeting

# Fisher 🔪 Installation ; https://github.com/jorgebucaran/fisher
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

fisher install jorgebucaran/replay.fish
fisher install berk-karaal/loadenv.fish




## 🥞 To find available packages, see ROS Index or use: https://index.ros.org/packages/page/1/time/#noetic
#   apt search ros-noetic

echo '
replay source /opt/ros/noetic/setup.bash

## 📦 rosbash ; https://wiki.ros.org/rosbash#fish
source /opt/ros/noetic/share/rosbash/rosfish

# 🐢 TurtleBot3 Configuration
set -x TURTLEBOT3_MODEL buger

set -x ROS_MASTER_URI http://10.10.14.19:11311
set -x ROS_HOSTNAME 10.10.14.19
' | tee $FISH_CONFIG_PATH >/dev/null






## 📦 rosbash ; https://wiki.ros.org/rosbash#fish
# I use replay instead of bass of fish moudles.
echo '### rosbash package configuration 📅 2025-01-09 19:38:37
## Automatically source setup.bash when cd-ing into a Catkin workspace or starting a new terminal

# Trigger this function whenever the current directory (PWD) changes
function catkinSource --on-variable PWD
    #🚣 Prevent execution during command substitution
    status --is-command-substitution; and return

    # Check if the current directory is a Catkin workspace
    if test -e ".catkin_workspace"; or test -e ".catkin_tools"
        replay source devel/setup.bash
        echo "Configured the folder as a workspace"
    end
end

# Trigger catkinSource function when the Fish prompt is first rendered (when opening a new terminal)
function __catkin_initial_source --on-event fish_prompt
    # Run catkinSource only if the terminal is in a Catkin workspace
    catkinSource
    # Unregister the function after the first execution
    functions -e __catkin_initial_source
end
' | tee $FISH_CONFIG_DIR/catkin.autosource.fish >/dev/null


# https://fishshell.com/docs/current/completions.html
# https://stackoverflow.com/questions/41161234/alias-with-whitespace-in-fish-shell


### 📦 rosbash package
#   check using command 🧮 code /opt/ros/noetic/share/rosbash/rosfish



source $FISH_CONFIG_PATH
