#!/bin/bash
# Session Caching (default 5 minute)
sudo -v

export BASH_CONFIG_PATH="$HOME/.bashrc"
export FISH_CONFIG_PATH="$HOME/.config/fish/config.fish"
mkdir -p "$(dirname "$FISH_CONFIG_PATH")"
export LOCAL_BIN_DIR="$HOME/.local/bin"
mkdir -p $LOCAL_BIN_DIR




### Minimum packages in order to install homebrew 🔗 https://docs.brew.sh/Homebrew-on-Linux#requirements
sudo apt install -y curl git
git config --global init.defaultBranch main

# 📦 GitHub CLI (🧮 gh) to login easily GitHub ; https://github.com/cli/cli/blob/trunk/docs/install_linux.md
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y


<<COMMENT
☑️ Note that if you installed gh using both apt and Homebrew, and either one is outdated
    , and when install or upgrade a package in homebrew the following error occurs: 📅 2025-02-06 21:17:38
  >>
    Error: The bottle for <package_name> could not be verified.

    This typically indicates an outdated or incompatible `gh` CLI.

    Please confirm that you're running the latest version of `gh`
    by performing an upgrade before retrying:

      brew update
      brew upgrade gh

☑️ If "build-essential" is not installed, the system cannot find standard headers like stdio.h, string.h, etc. 📅 2024-11-28 21:14:48
  This is because the standard library packages (like glibc) and compiler packages (like GCC or Clang) are separate in Linux systems.
COMMENT
sudo apt install -y build-essential gnupg



#### Install Package Manager in order to install latest and stable version for Development environment.
# 🚧 Requirements in Debian or Ubuntu ; https://docs.brew.sh/Homebrew-on-Linux#requirements
#   sudo apt-get install build-essential
echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Settings for homebrew -> It is moved to init_in_fish.fish 📅 2025-01-20 01:36:46





### Latest stable version available from Homebrew ; https://repology.org/project/fish/versions
: '
📦 fish
    https://repology.org/project/fish/versions
    https://formulae.brew.sh/formula/fish#default
    
    /home/linuxbrew/.linuxbrew/share/fish/config.fish

📦 fisher (Plugin manager for the Fish shell)
    https://repology.org/project/fisher-fish-package-manager/versions
    https://formulae.brew.sh/formula/fisher#default
'

# ☑️ The `fisher` command installed via Homebrew is not recognized immediately after installation. 📅 2024-12-25 16:38:45
#   Therefore, I configured Fish modules to be installed in "init_in_fish.fish" rather than the "init_in_bash.sh" file.
brew install fish fisher

echo '☑️  Issue: Bug; Create a symbolic link to the fish executable in /usr/bin/fish (PATH) directory to resolve VSCode and extension path recognitino issues. 📅 2024-11-16 00:32:18'
echo '  from VS Code settings.json, "terminal.integrated.defaultProfile.linux": "fish", '
echo '  from VS Code extension https://marketplace.visualstudio.com/items?itemName=bmalehorn.vscode-fish'
sudo ln -s /home/linuxbrew/.linuxbrew/bin/fish /usr/bin/fish
sudo ln -s /home/linuxbrew/.linuxbrew/bin/fish_indent /usr/bin/fish_indent

: '
☑️ Issue: Bug; Why does linuxbrew bin path not take precedence when using fish shell as the default in VSCode remote-SSH? 📅 2024-11-16 12:08:18
  - Environment 
    Fish shell was installed using the apt repository or GPG key method for Debian 12.
    The original fish shell was removed, and fish was reinstalled using Homebrew.
    empty: cat ~/.config/fish/config.fish
    empty: ls ~/.config/fish/conf.d/

  - Symptoms
    When connecting to the machine via terminal-based SSH, `echo $PATH` produces the expected result.
    When connecting via VSCode remote-SSH with the default shell set to bash, `echo $PATH` also produces the expected result.
    When connecting via VSCode remote-SSH with the default shell set to fish, `echo $PATH` shows an unexpected result. 
    The original expected `$PATH` is modified, with the `/etc/environment` PATH values being added redundantly to both the start and the end of `$PATH`.
~
  - Solution
    Add the following settings to VSCode `settings.json` file:
    {
      "terminal.integrated.defaultProfile.linux": "fish",
      "terminal.integrated.profiles.linux": {
        "fish": {
          "path": "/usr/bin/fish" # or "/home/linuxbrew/.linuxbrew/bin/fish"
        }
      }
    }
    Then restart VSCode.

  - ❓📰 Remaining Questions
    After applying the above settings once, removing the `"terminal.integrated.profiles.linux"` setting seems to still maintain the corrected behavior. Why?

  - References
    Similar problem: https://www.reddit.com/r/fishshell/comments/11zew52/issue_with_integrated_terminal_in_vscode/
'


########################################
#### Run init_in_fish.fish
# Define script_dir
script_dir=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
fish_init_file_path=$script_dir"/init_in_fish.fish"

# Check if the base directory exists
if [ ! -e "$fish_init_file_path" ]; then
    echo "🚨 The file $fish_init_file_path does not exist."
else
    fish $fish_init_file_path
fi



