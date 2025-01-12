: '📦 Install Fish shell
Notes
  - The package `software-properties-common` includes binary `apt-add-repository`.
  - `python3-launchpadlib` is required in order to use PPA (Persoanl Package Archives)
    in Ubuntu, Debian distributions,
    %shell> apt-cache show python3-launchpadlib | grep Priority
       >> Priority: optional
'
# Add the Fish shell PPA
sudo apt install -y software-properties-common python3-launchpadlib
sudo apt-add-repository -y ppa:fish-shell/release-3

# Install the Fish shell
sudo apt update && sudo apt install -y fish

# Change the default shell to Fish
sudo chsh -s $(which fish) $USER
