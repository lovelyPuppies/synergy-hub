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
echo '### ROS fish configuration
replay source /opt/ros/$ROS_DISTRO/setup.bash

## 📦 rosbash ; https://wiki.ros.org/rosbash#fish
source /opt/ros/$ROS_DISTRO/share/rosbash/rosfish

# 🐢 TurtleBot3 Configuration
set -x TURTLEBOT3_MODEL burger

## ☑️ from Bug that is not applied for soft uimit from docker-compose.yml
ulimit -Sn 1024
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
    # Run catkinSource only if the termi        nal is in a Catkin workspace
    catkinSource
    # Unregister the function after the first execution
    functions -e __catkin_initial_source
end
' | tee $FISH_CONFIG_DIR/catkin.autosource.fish >/dev/null


# https://fishshell.com/docs/current/completions.html
# https://stackoverflow.com/questions/41161234/alias-with-whitespace-in-fish-shell


### 📦 rosbash package
#   check using command 🧮 code /opt/ros/noetic/share/rosbash/rosfish



#### Temp .. 
: '
❌ Do not use frankjoshua/Rosserial. Instead, use the following: 📅 2025-01-13 16:43:04
  ```
  ros-noetic-rosserial-arduino
  # 📦 It creates `$WORKSPACE_DIR/ros_serial_uno3/lib/ros_lib` folder
  rosrun rosserial_arduino make_libraries.py $WORKSPACE_DIR/ros_serial_uno3/lib
  ```

Issues:
  When using frankjoshua/Rosserial Arduino Library@^0.9.1 with PlatformIO\'s lib_deps configuration, the following problems were encountered:

    1. AVR-GCC does not fully support the standard C++ library, which includes features like <cstring>, std::memcpy, and <cstdlib>. 
       - This limitation caused the library to fail on AVR platforms, such as Arduino Uno.
    2. The library is not optimized for AVR environments. Some code within the library does not function properly due to these platform limitations.

    PlatformIO\'s AVR-GCC does not have a complete standard library, which makes it incompatible with some parts of the frankjoshua library.

  ```ini
  ; paltformio.ini

  lib_deps =  
    ; The GitHub source also does not work because it does not comply with the PlatformIO compatibility format: https://github.com/ros-drivers/rosserial.git#noetic-devel
    ; https://registry.platformio.org/libraries/frankjoshua/Rosserial%20Arduino%20Library
    ; https://github.com/frankjoshua/rosserial_arduino_lib
    frankjoshua/Rosserial Arduino Library@^0.9.1

Comparison: frankjoshua/Rosserial Arduino Library vs make_libraries.py
  Features                  frankjoshua Library             make_libraries.py
  Update Status             Not updated for 4 years         Regularly updated to match ROS versions
  Memory Optimization       Limited                         Optimized for AVR boards
  ROS Message Type Support  Not possible                    Custom message types supported
  AVR-GCC Compatibility     Likely incomplete               Higher compatibility
  ROS Tool Integration      None                            Direct integration with official ROS tools
'
sudo apt install -y ros-noetic-rosserial ros-noetic-rosserial-server ros-noetic-rosserial-arduino
# 📦 It create `$WORKSPACE_DIR/ros_serial_uno3/lib/ros_lib` folder

source $FISH_CONFIG_PATH
cd .

rosrun rosserial_arduino make_libraries.py $WORKSPACE_DIR/ros_serial_uno3/lib


# ros-noetic-rosserial
#   Depends       ros-noetic-rosserial-client, ros-noetic-rosserial-msgs, ros-noetic-rosserial-python
# ros-noetic-rosserial-server
#   Depends       ros-noetic-roscpp, ros-noetic-rosserial-msgs, ros-noetic-std-msgs, ros-noetic-topic-tools
# ros-noetic-rosserial-arduino
#   Depends       arduino-core, ros-noetic-message-runtime, ros-noetic-rospy, ros-noetic-rosserial-client, ros-noetic-rosserial-msgs, ros-noetic-rosserial-python

sudo apt install -y tree sshpass
