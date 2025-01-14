#!/usr/bin/env fish

##### 📦 Install GPU driver 🔪 NVIDIA Driver
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





##### 📦 Install GPU driver 🔪 NVIDIA CUDA Toolkit ; https://docs.nvidia.com/cuda/cuda-installation-guide-linux/#common-installation-instructions-for-ubuntu
# https://developer.nvidia.com/cuda-toolkit-archive
## 3.8.4. Common Installation Instructions for Ubuntu
# These instructions apply to both local and network installation for Ubuntu.
# Update the Apt repository cache:
# Install CUDA SDK:
# ⚠️ Note These two commands must be executed separately.
sudo apt install cuda-toolkit
To include all GDS packages:

sudo apt install nvidia-gds
## For native arm64-Jetson repos, install the additional packages:
# sudo apt install cuda-compat

# 😠
echo "❗  Reboot the system. Installation of cuda-toolkit is complete."

## Perform the Post-installation Actions ; https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#post-installation-actions


## 📰📰📰📰📰📰📰📰📰




##### 📦 Install GPU driver 🔪 NVIDIA NVIDIA Container Toolkit ; https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
### Installation
# Configure the production repository:
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
and curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

## Optionally, configure the repository to use experimental packages:
# sed -i -e '/experimental/ s/^#//g' /etc/apt/sources.list.d/nvidia-container-toolkit.list

## Update the packages list from the repository and Install the NVIDIA Container Toolkit packages:
and sudo apt-get update
and sudo apt-get install -y nvidia-container-toolkit

### Configuration (❗ in Case of Root Mode)
# Configure the container runtime by using the nvidia-ctk command:
#   The nvidia-ctk command modifies the /etc/docker/daemon.json file on the host. The file is updated so that Docker can use the NVIDIA Container Runtime.
and sudo nvidia-ctk runtime configure --runtime=docker
# Restart the Docker daemon:
and sudo systemctl restart docker

## Check available:
# docker run --rm --gpus all nvidia/cuda:12.6.3-base-ubuntu24.04 nvidia-smi
# 🪱 NVIDIA SMI (System Management Interface)
and nvidia-smi


#####
: '📦 Qt
  https://download.qt.io/official_releases/online_installers
  https://doc.qt.io/qt-6/get-and-install-qt-cli.html#installing-with-user-interaction

  ☑️ (Issue: Bug); Download/Run Qt Online Installer taking too long ; https://stackoverflow.com/questions/48956637/qt-online-installer-taking-too-long 📅 2025-01-13 11:24:15
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
