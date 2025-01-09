#!/usr/bin/env fish
# 🐟 Fish Shell initialization
set -Ux FISH_CONFIG_PATH "$HOME/.config/fish/config.fish"
touch $FISH_CONFIG_PATH
set -U fish_greeting

# Fisher 🔪 Installation ; https://github.com/jorgebucaran/fisher
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

fisher install jorgebucaran/replay.fish
fisher install berk-karaal/loadenv.fish




# 🥞 To find available packages, see ROS Index or use: https://index.ros.org/packages/page/1/time/#noetic
#   apt search ros-noetic

echo "replay source /opt/ros/noetic/setup.bash" | tee $FISH_CONFIG_PATH > /dev/null
source $FISH_CONFIG_PATH

