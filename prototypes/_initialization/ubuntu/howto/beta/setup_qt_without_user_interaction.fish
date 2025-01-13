#!/usr/bin/env fish
function on_interrupt
    echo -e "\nScript interrupted. Exiting..."
    # Kill all child processes in the same process group
    kill -- -$fish_pid
    exit 1
end
trap on_interrupt SIGINT


##### 📦 Qt
# Variant of the original source is 🔗 prototypes/_initialization/ubuntu/init_in_fish_semi_automatic-vision.fish
set qt_installation_package "qt6.8.1-full"
set qt_installer_name "qt-unified-linux-arm64-online.run"

echo "📝  It will install `$qt_installer_name` installer, `$qt_installation_package` package."
echo "⌨️  Enter your Qt account email: "
read qt_email
echo ""

echo "⌨️  Enter your Qt account password: "
read -s qt_pw
echo ""

wget -O ~/Downloads/qt-unified "https://download.qt.io/official_releases/online_installers/"$qt_installer_name
chmod 700 ~/Downloads/qt-unified

set qt_installer_file_path "$HOME/Downloads/qt-unified"
set install_dir "$HOME/Qt"

echo Accept | $qt_installer_file_path \
    --root $install_dir \
    --email $qt_email \
    --pw $qt_pw \
    --accept-licenses --default-answer --confirm-command \
    --mirror "https://ftp.jaist.ac.jp/pub/qtproject/" \
    install $qt_installation_package
