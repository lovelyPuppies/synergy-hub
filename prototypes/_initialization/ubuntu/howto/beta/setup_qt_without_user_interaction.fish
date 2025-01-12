#!/usr/bin/env fish

# wget -O ~/Downloads/qt-unified https://download.qt.io/official_releases/online_installers/qt-unified-linux-x64-online.run
wget https://download.qt.io/official_releases/online_installers/qt-unified-linux-arm64-online.run
chmod 700 ~/Downloads/qt-unified
## if in ARM
# wget https://download.qt.io/official_releases/online_installers/qt-unified-linux-arm64-online.run
~/Downloads/qt-unified-linux-x64-online.run


echo "⌨️  Enter your Qt account password: "
read -s qt_pw
echo ""

wget -O ~/Downloads/qt-unified https://download.qt.io/official_releases/online_installers/qt-unified-linux-x64-online.run
chmod 700 ~/Downloads/qt-unified

set qt_installer "$HOME/Downloads/qt-unified"
set install_dir "$HOME/Qt"
set qt_email "wbfw109v2@gmail.com"

echo Accept | $qt_installer \
    --root $install_dir \
    --email $qt_email \
    --pw $qt_pw \
    --accept-licenses --default-answer --confirm-command \
    install qt6.8.0-full
# qt6.8.0-full-dev
