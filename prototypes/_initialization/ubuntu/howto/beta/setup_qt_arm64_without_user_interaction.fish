# Variant of the original source is 🔗 prototypes/_initialization/ubuntu/init_in_fish_semi_automatic-vision.fish
#!/usr/bin/env fish
function on_interrupt
    echo -e "\nScript interrupted. Exiting..."
    # Kill all child processes in the same process group
    kill -- -$fish_pid
    exit 1
end
trap on_interrupt SIGINT
### 📰 Required to test using Maintenance Tool.
## linux: update installation with Qt Maintenance Tool
# echo Accept | $qt_installer_file_path \
#     --root $install_dir \
#     --email $qt_email \
#     --pw $qt_pw \
#     --accept-licenses --default-answer --confirm-command \
#     --mirror "https://ftp.jaist.ac.jp/pub/qtproject/" \
#     install $qt_installation_package
## MaintenanceTool.run --accept-licenses --default-answer --confirm-command install qt.qt6.681.gcc_64
# ./MaintenanceTool --help | grep remove
#$HOME/Qt/MaintenanceTool --accept-licenses --default-answer --confirm-command remove qt.qt6.680.gcc_64

##### 📦 Qt
# Check if libxcb-cursor0 is installed
function check_libxcb_cursor0
    : '

    ldd ~/Downloads/qt-unified 
    
    ☑️ (Issue: Error) When run QT installer, 📅 2025-01-13 11:56:35
      Error while loading shared libraries
        >> libxcb-cursor.so.0: cannot open shared object file: No such file or directory
      Error while running QT installer,
        [8478] XCBError : The required XCB cursor platform library was not found! : The required XCB cursor platform library was not found!
      https://github.com/nomic-ai/gpt4all-chat/issues/3
        Please use your distribution\'s package manager to install it.
          Ubuntu/Debian-based: apt install libxcb-cursor0 libxcb-cursor-dev
    '
    if dpkg -s libxcb-cursor0 >/dev/null 2>&1
        echo "libxcb-cursor0 is already installed."
    else
        echo "libxcb-cursor0 is not installed. Installing..."
        sudo apt update && sudo apt install -y libxcb-cursor0 libxcb-cursor-dev
        echo "libxcb-cursor0 installation complete."
    end
end
check_libxcb_cursor0



set qt_installation_package "qt6.8.1-full"
set qt_installer_name "qt-unified-linux-arm64-online.run"
set qt_mirror_url "https://ftp.jaist.ac.jp/pub/qtproject/official_releases/online_installers/"$qt_installer_name


if test -e ~/Downloads/qt-unified
    echo "Qt installer already exists."
else
    echo "Downloading Qt installer..."
    wget -O ~/Downloads/qt-unified $qt_mirror_url
    chmod 700 ~/Downloads/qt-unified
end

echo "📝  It will install `$qt_installer_name` installer, `$qt_installation_package` package."
echo "⌨️  Enter your Qt account email: "
read qt_email
echo ""

echo "⌨️  Enter your Qt account password: "
read -s qt_pw
echo ""

set qt_installer_file_path "$HOME/Downloads/qt-unified"
set install_dir "$HOME/Qt"


#! Error 로 인해 자동화 불가능. 오류 발생 시 자동으로 취소되서 처음부터 다시 설치해야 함.
# echo Accept | $qt_installer_file_path \
#     --root $install_dir \
#     --email $qt_email \
#     --pw $qt_pw \
#     --accept-licenses --default-answer --confirm-command \
#     --verbose \
#     --mirror "https://ftp.jaist.ac.jp/pub/qtproject/" \
#     install $qt_installation_package
$qt_installer_file_path \
    --root $install_dir \
    --email $qt_email \
    --pw $qt_pw \
    --accept-licenses --confirm-command \
    --verbose \
    --mirror "https://ftp.jaist.ac.jp/pub/qtproject/" \
    install $qt_installation_package
# --default-answer --confirm-command \
# qt.qt6.681.linux_gcc_arm64
## https://forum.qt.io/topic/159579/installation-qt-qt6-680-linux_gcc_arm64-on-rpi5-failed-with-qt-6-8-0-gcc_arm64-bin-qmake-process-crashed/2
## https://www.qt-dev.com/board.php?board=qnaboard&command=body&no=1019
## https://forum.qt.io/topic/159564/qt-creator-installer-setup-fails-on-linux-arm-process-crashed
