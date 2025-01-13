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
      
    '
    if dpkg -s libxcb-cursor0 >/dev/null 2>&1
        echo "libxcb-cursor0 is already installed."
    else
        echo "libxcb-cursor0 is not installed. Installing..."
        sudo apt update && sudo apt install -y libxcb-cursor0
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

echo Accept | $qt_installer_file_path \
    --root $install_dir \
    --email $qt_email \
    --pw $qt_pw \
    --accept-licenses --default-answer --confirm-command \
    --mirror "https://ftp.jaist.ac.jp/pub/qtproject/" \
    install $qt_installation_package
