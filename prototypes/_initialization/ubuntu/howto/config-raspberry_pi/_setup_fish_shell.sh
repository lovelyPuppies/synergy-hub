#!/usr/bin/bash
# 📅 Written at 2025-01-12 19:58:15
<<COMMENT
📦 Install Fish shell
Notes
  - The package "software-properties-common" includes binary "apt-add-repository".
  - "python3-launchpadlib" is required in order to use PPA (Persoanl Package Archives)
    in Ubuntu, Debian distributions,
    %shell> apt-cache show python3-launchpadlib | grep Priority
       >> Priority: optional


🚨 (Issue); E: The repository 'https://ppa.launchpadcontent.net/fish-shell/release-3/ubuntu bookworm Release' does not have a Release file. 📅 2025-01-12 19:55:55
  >>
    N: Updating from such a repository can't be done securely, and is therefore disabled by default.
    N: See apt-secure(8) manpage for repository creation and user configuration details.
  When
    # Add the Fish shell PPA
    sudo apt install -y software-properties-common python3-launchpadlib
    sudo apt-add-repository -y ppa:fish-shell/release-3
    sudo apt update && sudo apt install fish
COMMENT



#### https://software.opensuse.org/download.html?project=shells%3Afish%3Arelease%3A3&package=fish
echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null


# Install the Fish shell
sudo apt update && sudo apt install -y fish


# ❗ Change the default shell to Fish
sudo chsh -s $(which fish) $USER
