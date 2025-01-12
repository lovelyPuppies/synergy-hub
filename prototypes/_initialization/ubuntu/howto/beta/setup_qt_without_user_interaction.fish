#!/usr/bin/env fish
function on_interrupt
    echo -e "\nScript interrupted. Exiting..."
    # Kill all child processes in the same process group
    kill -- -$fish_pid
    exit 1
end
trap on_interrupt SIGINT


#####
# https://download.qt.io/official_releases/online_installers
# https://doc.qt.io/qt-6/get-and-install-qt-cli.html#installing-with-user-interaction
echo "⌨️  Enter your Qt account email: "
read qt_email
echo ""

echo "⌨️  Enter your Qt account password: "
read -s qt_pw
echo ""

wget -O ~/Downloads/qt-unified https://download.qt.io/official_releases/online_installers/qt-unified-linux-arm64-online.run
chmod 700 ~/Downloads/qt-unified

set qt_installer "$HOME/Downloads/qt-unified"
set install_dir "$HOME/Qt"

echo Accept | $qt_installer \
    --root $install_dir \
    --email $qt_email \
    --pw $qt_pw \
    --accept-licenses --default-answer --confirm-command \
    install qt6.8.1-full
