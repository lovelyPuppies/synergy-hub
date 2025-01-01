#!/usr/bin/env fish
: ' ❔ Kubuntu settings
Right click the Task bar - Show Panel Configuration
    - Panel Settings
        - Visibility: ✔️ Auto hide
'










: '
✅ (how-to) edit for .hwp files in Linux; 📅 2024-12-20 16:46:04
    Hancom docs ; https://www.hancomdocs.com/ko/home
    License ; https://www.hancomdocs.com/ko/settings/subscription/product
        ❕ Free for 2GB
'
### Update and upgrade packages
sudo apt update



#### Install (Clipboard Manager: gnome-shell-extension-clipboard-indicator) in Ubuntu 📅 2024-10-31 19:17:00
sudo apt install -y gnome-shell-extensions
## 🚧 Prerequsite
#    Chrome - GNOME Shell integration ; https://chromewebstore.google.com/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep
#   😠 Reboot required

### 1. Available option 1 (recommended)
# 😠 manually run: browser https://extensions.gnome.org/extension/779/clipboard-indicator/ and click the "Install"

### 1. Available option 2 (not recommended)
# set gnome_shell_extension_dir ~/.local/share/gnome-shell/extensions
# git clone https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator.git $gnome_shell_extension_dir/clipboard-indicator@tudmotu.com
# sudo systemctl restart gdm
## 😠 manually run: 
# gnome-extensions enable clipboard-indicator@tudmotu.com

### 2. Change Keyboard shortcut
echo "[/]
toggle-menu=['<Super>c']
" | dconf load /org/gnome/shell/extensions/clipboard-indicator/







##### 📦 OnlyOffice Desktop; Tool with high compatibility with Office365 ; https://helpcenter.onlyoffice.com/installation/desktop-install-ubuntu.aspx
# The default tool on Ubuntu, LibreOffice Impress, does not have good compatibility
#   , causing issues such as incorrect font sizes. In the case of PowerPoint files, videos embedded in slides often fail to play properly. 📅 2024-12-12 00:00:03
# Add GPG key:
mkdir -p -m 700 ~/.gnupg
gpg --no-default-keyring --keyring gnupg-ring:/tmp/onlyoffice.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
chmod 644 /tmp/onlyoffice.gpg
sudo chown root:root /tmp/onlyoffice.gpg
sudo mv /tmp/onlyoffice.gpg /usr/share/keyrings/onlyoffice.gpg
# Add desktop editors repository:
echo 'deb [signed-by=/usr/share/keyrings/onlyoffice.gpg] https://download.onlyoffice.com/repo/debian squeeze main' | sudo tee -a /etc/apt/sources.list.d/onlyoffice.list
# Update the package manager cache:
sudo apt update -y
# Now the editors can be easily installed using the following command:
sudo apt install -y onlyoffice-desktopeditors
### 😠 The installation of ttf-mscorefonts-installer requires user interaction to agree to the license agreement





##### STM32 📅 2024-12-04 15:27:53
# 🚣 Press "q" and then "y" when the license terms appear to quickly install packages.
## 📦 Install STM32 Cube Clt ; https://www.st.com/en/development-tools/stm32cubeclt.html

# Change to temporary directory
pushd /tmp

# Set variables
set zip_file_name stm32cubeclt.zip
set header_user_agent "User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:90.0) Gecko/20100101 Firefox/90.0"
set unzip_dir_name (basename $zip_file_name .zip)
set target_dir $HOME/st/stm32cubeclt

# Set URL and download the ZIP file
# 😠 you may requires new valid url link from Cube Clt url.
set url "https://www.st.com/content/ccc/resource/technical/software/application_sw/group0/70/b6/c2/ba/11/08/43/6c/STM32CubeCLT-Lnx/files/st-stm32cubeclt_1.17.0_23554_20241124_1810_amd64.sh.zip/jcr:content/translations/en.st-stm32cubeclt_1.17.0_23554_20241124_1810_amd64.sh.zip"
wget --show-progress -O $zip_file_name --header="$header_user_agent" $url

# Unzip the file into the specified directory
unzip $zip_file_name -d $unzip_dir_name
pushd $unzip_dir_name

# Find the install script
set install_exec_file (find . -maxdepth 1 -type f -name "st-stm32cubeclt*\.sh")

# Execute the install script
if test -n "$install_exec_file"
    # 😠 Manual user interaction is needed
    bash $install_exec_file
    # 😠 You must manually set the default path to match the VSCode configuration. Using variables like $HOME is not allowed.
    #  📁 dir: /home/wbfw109v2/st/stm32cubeclt
    # 😠 you want to manually run not through STM32 VSCode extension
    #   , you may need to run in the default_dir $HOME/st/stm32cubeclt/STLinkUpgrade.sh because of jre reference may be hardcorded
else
    echo "Install script not found."
    return 1
end

# Pop back to the previous directory
popd

# No need to clean up since files are in /tmp
# Pop back to the original directory
popd



## 📦 Install STM32 Cube MX ; https://www.st.com/en/development-tools/stm32cubemx.html
# Change to temporary directory
pushd /tmp

# Set variables
set zip_file_name stm32cubemx.zip
set header_user_agent "User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:90.0) Gecko/20100101 Firefox/90.0"
set unzip_dir_name (basename $zip_file_name .zip)
set target_dir $HOME/st/stm32cubemx

# Set URL and download the ZIP file
set url "https://www.st.com/content/ccc/resource/technical/software/sw_development_suite/group1/4e/b5/ca/af/8b/51/44/aa/stm32cubemx-lin-v6-12-1/files/stm32cubemx-lin-v6-12-1.zip/jcr:content/translations/en.stm32cubemx-lin-v6-12-1.zip"
wget --show-progress -O $zip_file_name --header="$header_user_agent" $url

# Unzip the file into the specified directory
unzip $zip_file_name -d $unzip_dir_name
pushd $unzip_dir_name

# Find the install script
set install_exec_file (find . -maxdepth 1 -type f -name "SetupSTM32CubeMX-*")

# Execute the install script
if test -n "$install_exec_file"
    # 😠 Manual user interaction is needed
    $install_exec_file
    # nothing to set manually. default dir: $HOME/STM32CubeMX
    # ⚠️ you want to manually run not through STM32 VSCode extension
    #   , you need to run in the default_dir $HOME/STM32CubeMX/STM32CubeMX because of jre reference may be hardcorded
else
    echo "Install script not found."
    return 1
end

# Pop back to the previous directory
popd

# No need to clean up since files are in /tmp
# Pop back to the original directory
popd




## 📦 Install STM32 MCU Finder ; https://www.st.com/en/development-tools/st-mcu-finder-pc.html
# Change to temporary directory
pushd /tmp

# Set variables
set zip_file_name stm32mcufinder.zip
set header_user_agent "User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:90.0) Gecko/20100101 Firefox/90.0"
set unzip_dir_name (basename $zip_file_name .zip)
set target_dir $HOME/st/stm32mcufinder

# Set URL and download the ZIP file
set url "https://www.st.com/content/ccc/resource/technical/software/sw_development_suite/group1/bc/e7/29/51/21/17/4a/9c/st-mcu-finderlin-v6-1-0/files/st-mcu-finderlin-v6-1-0.zip/jcr:content/translations/en.st-mcu-finderlin-v6-1-0.zip"
wget --show-progress -O $zip_file_name --header="$header_user_agent" $url

# Unzip the file into the specified directory
unzip $zip_file_name -d $unzip_dir_name
pushd $unzip_dir_name

# Find the install script
set install_exec_file (find . -maxdepth 1 -type f -name "SetupSTMCUFinder*")

# Execute the install script
if test -n "$install_exec_file"
    # 😠 Manual user interaction is needed
    $install_exec_file
    # nothing to set manually. default dir: $HOME/STMCUFinder
    # 😠 but you want to manually run not through STM32 VSCode extension
    #   , you may need to run in the default_dir $HOME/STMCUFinder/STMCUFinder because of jre reference may be hardcorded
else
    echo "Install script not found."
    return 1
end


# Pop back to the previous directory
popd

# No need to clean up since files are in /tmp
# Pop back to the original directory
popd






















#### 🧪 Install Wine for Kakaotalk with locale-Korean 
### install Wine ; https://gitlab.winehq.org/wine/wine/-/wikis/Debian-Ubuntu 📅 2024-12-27 15:43:41 
## Preparation
sudo dpkg --add-architecture i386
cat /etc/os-release


# Download and add the repository key:
sudo mkdir -pm755 /etc/apt/keyrings
wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key -

## Add the repository: 🌳 for Ubuntu 24
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/oracular/winehq-oracular.sources
# Update the package information:
sudo apt update

## Install Wine
sudo apt install -y --install-recommends winehq-devel winetricks

## configure Wine to use Windows 10
winetricks -q win10


### Install Kakaotalk
wget https://app-pc.kakaocdn.net/talk/win32/KakaoTalk_Setup.exe -P ~/Downloads/
LANG="ko_KR.UTF-8" wine ~/Downloads/KakaoTalk_Setup.exe
# installed in "$HOME/.wine/drive_c/Program Files (x86)/Kakao/KakaoTalk/KakaoTalk.exe"

## 😠 manually config: 
# ✔️ Pin the KakaoTalk program to the left Dock on the Ubuntu Desktop
# in Kakaotalk settings to prevent Korean text from breaking or displaying incorrectly
#   - settings - Display
#     - Fonts - ✔️ NanumGothic
