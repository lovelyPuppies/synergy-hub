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

echo '
function roscd
    cd (rospack find $argv[1])
end

function rosls
    ls (rospack find $argv[1])
end

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

replay source /opt/ros/noetic/setup.bash
replay source /workspace/devel/setup.bash
'
" | tee $FISH_CONFIG_PATH > /dev/null

source $FISH_CONFIG_PATH

