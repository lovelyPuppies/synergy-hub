#!/usr/bin/env fish

##### 📦 GPU 🔪 NVIDIA Driver
sudo apt update && sudo apt upgrade -y

### Install NVIDIA Driver
# 🗑️ ubuntu-drivers autoinstall          🗑️ Deprecated: please use "install" instead
sudo ubuntu-drivers install
: '🧮 ubuntu-drivers devices
  >> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0 ==
    modalias : pci:v000010DEd00002783sv00001458sd0000413Bbc03sc00i00
    vendor   : NVIDIA Corporation
    model    : AD104 [GeForce RTX 4070 SUPER]
    driver   : nvidia-driver-550-server-open - distro non-free
    driver   : nvidia-driver-550-server - distro non-free
    driver   : nvidia-driver-560-open - distro non-free recommended
    driver   : nvidia-driver-560 - distro non-free
    driver   : nvidia-driver-565-server - distro non-free
    driver   : nvidia-driver-565-server-open - distro non-free
    driver   : xserver-xorg-video-nouveau - distro free builtin
'
: '🧮 ubuntu-drivers --gpgpu list
  # 🪱 gpgpu; General-Purpose computing on Graphics Processing Units
  >> This is gpgpu mode
    nvidia-driver-560-open, (kernel modules provided by linux-modules-nvidia-560-open-generic)
    nvidia-driver-560, (kernel modules provided by linux-modules-nvidia-560-generic)
    nvidia-driver-550-server, (kernel modules provided by linux-modules-nvidia-550-server-generic)
    nvidia-driver-565-server-open, (kernel modules provided by linux-modules-nvidia-565-server-open-generic)
    nvidia-driver-550-server-open, (kernel modules provided by linux-modules-nvidia-550-server-open-generic)
    nvidia-driver-565-server, (kernel modules provided by linux-modules-nvidia-565-server-generic)
'
# 🧮 vulkaninfo > /tmp/txt; code /tmp/txt

### Install CUDA Toolkit ; https://docs.nvidia.com/cuda/cuda-installation-guide-linux/
# https://developer.nvidia.com/cuda-toolkit-archive
sudo apt install -y nvidia-cuda-toolkit



# 🪱 NVIDIA SMI (System Management Interface)
nvidia-smi


#####
: '📦 Qt
  https://download.qt.io/official_releases/online_installers
  https://doc.qt.io/qt-6/get-and-install-qt-cli.html#installing-with-user-interaction

  ☑️ (Issue: Bug); Qt Online Installer taking too long ; https://stackoverflow.com/questions/48956637/qt-online-installer-taking-too-long 📅 2025-01-13 11:24:15
    ➡️ Set Mirror arguments when run installer ; https://download.qt.io/static/mirrorlist/
      Online Installer uses random mirrors which can be slow to download.
    # In Korea, the Japan servers are the most suitable due to proximity and stability.

    When install first time, you can set the mirror by command line.
      %shell> $HOME/qt-unified --mirror https://ftp.jaist.ac.jp/pub/qtproject/
    or, If you want to use the MaintenanceTool.
      %shell> $HOME/Qt/MaintenanceTool --mirror https://ftp.jaist.ac.jp/pub/qtproject/
'

set qt_installation_package "qt6.8.1-full-dev"
set qt_installer_name "qt-unified-linux-x64-online.run"

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
