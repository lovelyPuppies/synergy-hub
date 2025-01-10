#!/usr/bin/env fish


# Load Modules
source prototypes/_initialization/ubuntu/fish_modules/_import_all.fish

function on_interrupt
    echo -e "\nScript interrupted. Exiting..."
    # Kill all child processes in the same process group
    kill -- -$fish_pid
    exit 1
end
trap on_interrupt SIGINT


set script_dir /home/wbfw109v2/repos/synergy-hub/prototypes/_initialization/ubuntu

### 📦 (Verified) GIMP ; https://flathub.org/apps/com.microsoft.Edge 📅 2024-12-25 23:12:02
#   ; Image editor, photo retouching, and graphic design tool
flatpak install -y --user flathub com.microsoft.Edge
# Define alias for 'gimp' in an interactive session
set unique_comment "# Add alias for gimp from flatpak"
set alias_function (echo "
    function gimp
        flatpak --user run com.microsoft.Edge \$argv
    end
" | prettify_indent_via_pipe | string split0)

# Call the function to update the config
update_fish_interactive_block --unique-comment="$unique_comment" --contents="$alias_function"



# # 경로 설정
# set FISH_SCRIPT_PATH "/home/wbfw109v2/repos/synergy-hub/prototypes/_initialization/ubuntu/file_supervisor/inotify-make_fish_utilities_executable.fish"
# set SERVICE_FILE_PATH "$HOME/.config/systemd/user/inotify-make_fish.service"

# # 실행 권한 부여
# chmod +x "$FISH_SCRIPT_PATH"

# # 2. Systemd 서비스 파일 생성
# mkdir -p "$HOME/.config/systemd/user"
# echo "[Unit]
# Description=Inotify service for Fish utilities (User Scope)
# After=network.target

# [Service]
# ExecStart=/usr/bin/fish $FISH_SCRIPT_PATH
# Restart=always
# RestartSec=5

# [Install]
# WantedBy=default.target
# " >"$SERVICE_FILE_PATH"

# # 3. Systemd 설정 및 서비스 시작
# systemctl --user daemon-reload
# systemctl --user enable inotify-make_fish.service
# systemctl --user start inotify-make_fish.service

# # 상태 확인
# systemctl --user status inotify-make_fish.service --no-pager

# systemctl --user disable inotify-make_fish.service
# systemctl --user stop inotify-make_fish.service
