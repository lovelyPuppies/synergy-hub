#!/usr/bin/env fish
##### Define
### 📁 MY Directory Structures 📅 2024-12-14 21:08:26
: '
📂 $HOME/repos/
├── synergy-hub             // 🥇 My Mono Repository
│   <path_for_custom_driver_source_according_to_kernel_version>
├── 📂 bootloaders/
│   ├── grub/
│   ├── u-boot/
│   ├── u-boot-raspberry-pi/
├── 📂 kernels/
│   ├── linux-5.10
│   ├── linux
│   └── raspberry-pi        // https://github.com/raspberrypi/linux
├── 📂 yocto_project/
│   └── poky
└── 📂 projects
    └── <A team_project>
'
set -l script_dir (dirname (realpath (status filename)))

# Create the main directories if it doesn't exist
set repos_dir $HOME/repos
mkdir -p $repos_dir

set bootloaders_dir $repos_dir/bootloaders
mkdir -p $bootloaders_dir
set kernels_dir $repos_dir/kernels
mkdir -p $kernels_dir
set yocto_project_dir $repos_dir/yocto_project
mkdir -p $yocto_project_dir
set projects_dir $repos_dir/projects
mkdir -p $projects_dir

# 📰 is it required?...
set current_user (id --user --name)


# Define the Fish configuration file path. Ensure Path.
set -Ux FISH_CONFIG_PATH "$HOME/.config/fish/config.fish"
set fish_config_interactive_block_start "if status --is-interactive"
set -Ux FISH_COMPLETIONS_DIR "$HOME/.config/fish/completions"
set -Ux BASH_PROFILE_PATH "$HOME/.bash_profile"
touch $BASH_PROFILE_PATH # Some devices like Raspberry pi does not exist this file default. 📅 2024-12-18 16:22:13
set -Ux BASHRC_PATH "$HOME/.bashrc"
set -Ux LOCAL_SHARE_PATH "$HOME/.local/share"
set -Ux LOCAL_BIN_PATH "$HOME/.local/bin"
set -Ux USER_SYSTEMD_DIR "$HOME/.config/systemd/user"
mkdir -p $USER_SYSTEMD_DIR

set -U fish_user_paths $LOCAL_BIN_PATH $fish_user_paths
set -U fish_greeting ""
set is_wsl 1
# /proc is a virtual filesystem providing process and system info, dynamically created by the kernel at runtime.
#   /proc/version reveals the kernel version and build details of the running system.

if grep -Fqi Microsoft /proc/version
    set is_wsl 0
    echo "Detected WSL. Skipping installations specific to pure Linux environments."
end



### Font installation directory
set font_dir ~/.local/share/fonts
mkdir -p $font_dir



### Fish plugins
: '
Fish plugins
  ⚓ replay.fish ; https://github.com/jorgebucaran/replay.fish      
'
fisher install jorgebucaran/replay.fish






##### ...
### Load Modules
source $script_dir/fish_modules/_import_all.fish



### prepend "interactive block" to FISH_CONFIG_PATH
# Define the unique comment and interactive block start
set unique_comment "# Add interactive block"

# Check if the 'if status --is-interactive' block exists
if not grep -q "$unique_comment" $FISH_CONFIG_PATH
    # Create a temporary file
    set tmp_file (mktemp)

    # Insert the 'if status --is-interactive' block at the beginning
    awk -v interactive_block_start="$fish_config_interactive_block_start" -v unique_comment="$unique_comment" '
        BEGIN {
            print "" unique_comment
            print interactive_block_start
            print "    "
            print "end"
            print ""
        }
        { print }
    ' $FISH_CONFIG_PATH >$tmp_file

    # Overwrite the original file
    mv $tmp_file $FISH_CONFIG_PATH
end



###🔏 Add user to groups to avoid requiring "sudo" for specific hardware access. 📅 2024-12-04 13:04:14
# Add user to the video group for GPU and video device access.
# Grants access to /dev/video* and /dev/dri/* for webcams, GPUs, and other video devices.
sudo usermod -aG video $USER

# Add user to the dialout group for serial and USB-to-serial device access.
# Grants access to /dev/ttyUSB*, /dev/ttyS*, and similar serial communication ports.
sudo usermod -aG dialout $USER

# Add user to the plugdev group for removable device access.
# Grants access to /dev/bus/usb/* for removable USB devices like flash drives.
sudo usermod -aG plugdev $USER

# Add user to the audio group for audio input and output device access.
# Grants access to /dev/snd/* for audio cards, microphones, and speakers.
sudo usermod -aG audio $USER

# Add user to the input group for input device access.
# Grants access to /dev/input/* for reading input events from keyboards, mice, and touchscreens.
sudo usermod -aG input $USER

# Add user to the disk group for direct disk device access.
# Grants access to /dev/sd*, /dev/hd*, and similar block devices for managing disks and partitions.
sudo usermod -aG disk $USER

echo "❗ NOTE: The user has been added to the groups. Please restart the session, re-login, or reboot for the changes to take effect."



### Check if ~/.bash_profile already contains the Fish shell redirect for SSH connections, and add it if missing
# 🔡 Snippet 📅 2024-11-16 13:24:17
set unique_comment '### When SSH connection is active, switch to Fish shell'
if not grep -Fxq "$unique_comment" "$BASH_PROFILE_PATH"
    echo "
    $unique_comment"'
    # "$HOME/.bash_profile" is the last file loaded when starting a login shell in Bash.
    if [ -n "$SSH_CONNECTION" ]; then
      exec fish
    fi
    ' | prettify_indent_via_pipe | tee -a $BASH_PROFILE_PATH >/dev/null
    echo -e "\n" >>"$BASH_PROFILE_PATH"
end





##### Packages Managed by "brew" command in "fish" shell
echo "🥞 Installing available latest stable versions from Homebrew in fish shell ..."
## Latest stable version available from Homebrew

echo "▶️  Installing essential tools for downloading, managing packages, and enhancing developer productivity ..."
: '
📦 curl
    https://repology.org/project/curl/versions
    https://formulae.brew.sh/formula/curl#default
📦 wget
    https://repology.org/project/wget/versions
    https://formulae.brew.sh/formula/wget#default
📦 gpg; gnupg
    https://repology.org/project/gnupg/versions
    https://formulae.brew.sh/formula/gnupg#default
📦 awk; gawk
    https://repology.org/project/gawk/versions
    https://formulae.brew.sh/formula/gawk#default

📦 git
    https://repology.org/project/git/versions
    https://formulae.brew.sh/formula/git#default
    ==> Caveats
    ==> git
    The Tcl/Tk GUIs (e.g. gitk, git-gui) are now in the `git-gui` formula.
    Subversion interoperability (git-svn) is now in the `git-svn` formula.

    Bash completion has been installed to:
    /home/linuxbrew/.linuxbrew/etc/bash_completion.d
📦 gh; github-cli
    https://repology.org/project/github-cli/versions
    https://formulae.brew.sh/formula/gh#default
'
brew install curl wget gnupg gawk git gh
git config --global init.defaultBranch main
git config --global core.editor "code --wait"


: '
📦 tree
    https://formulae.brew.sh/formula/tree
'
# try run %shell> 🧮 tree -C
brew install tree


: '
📦 kmod ; Linux kernel module handling 📅 2024-12-04 14:42:03
    https://repology.org/project/kmod/versions
    https://formulae.brew.sh/formula/kmod#default

    It includes command: lsmod, modprobe, insmod, rmmod, depmod, modinfo.
    🚣 I use the latest stable kmod package in Homebrew because maintaining the latest version of kmod is crucial to ensuring compatibility with various newer kernel modules.
'
brew install kmod


: '
📦 e2fsprogs (Ext2 File System Programs) ; Utilities for the ext2, ext3, and ext4 file systems 📅 2024-12-12 19:02:38
    https://repology.org/project/e2fsprogs/versions
    https://formulae.brew.sh/formula/e2fsprogs#default
 
    ==> Caveats
    e2fsprogs is keg-only, which means it was not symlinked into /home/linuxbrew/.linuxbrew,
    because it conflicts with the bundled copy in `krb5`.

    If you need to have e2fsprogs first in your PATH, run:
      echo \'export PATH="/home/linuxbrew/.linuxbrew/opt/e2fsprogs/bin:$PATH"\' >> /home/wbfw109v2/.bash_profile
      echo \'export PATH="/home/linuxbrew/.linuxbrew/opt/e2fsprogs/sbin:$PATH"\' >> /home/wbfw109v2/.bash_profile

    For compilers to find e2fsprogs you may need to set:
      export LDFLAGS="-L/home/linuxbrew/.linuxbrew/opt/e2fsprogs/lib"
      export CPPFLAGS="-I/home/linuxbrew/.linuxbrew/opt/e2fsprogs/include"

    For pkg-config to find e2fsprogs you may need to set:
      export PKG_CONFIG_PATH="/home/linuxbrew/.linuxbrew/opt/e2fsprogs/lib/pkgconfig"

'
brew install e2fsprogs

# Define and add settings for e2fsprogs
set unique_comment "## [e2fsprogs] add binary dir to path"
if not grep -Fxq "$unique_comment" "$FISH_CONFIG_PATH"
    echo "
    $unique_comment
    fish_add_path /home/linuxbrew/.linuxbrew/opt/e2fsprogs/bin
    fish_add_path /home/linuxbrew/.linuxbrew/opt/e2fsprogs/sbin
    set -gx LDFLAGS \$LDFLAGS -L/home/linuxbrew/.linuxbrew/opt/e2fsprogs/lib
    set -gx CPPFLAGS \$CPPFLAGS -I/home/linuxbrew/.linuxbrew/opt/e2fsprogs/include
    set -gx PKG_CONFIG_PATH \$PKG_CONFIG_PATH:/home/linuxbrew/.linuxbrew/opt/e2fsprogs/lib/pkgconfig
    " | prettify_indent_via_pipe | tee -a $FISH_CONFIG_PATH >/dev/null
    echo -e "\n" >>"$FISH_CONFIG_PATH"
end




: '
📦🚀 avahi ; https://github.com/avahi/avahi
    https://repology.org/project/avahi/versions
    https://formulae.brew.sh/formula/avahi

    Service Discovery for Linux using mDNS/DNS-SD
'
brew install avahi









echo "▶️  Installing improved tools for speed and usability ..."

: '
📦🚀 bat ; https://github.com/sharkdp/bat
    https://repology.org/project/bat/versions
    https://formulae.brew.sh/formula/bat#default
    
    alternative of "cat".
    Developed in Rust.
'
brew install bat



: '
📦🚀 fd-find (fd); https://github.com/sharkdp/fd
    https://repology.org/project/fd-find/versions
    https://formulae.brew.sh/formula/fd#default
    
    alternative of "find".
    Developed in Rust.

    🛍️ Usage e.g. %shell>
        fd --extension fish
'
brew install fd


: '
📦🚀 lsd: https://github.com/lsd-rs/lsd
    https://repology.org/project/lsd/versions
    https://formulae.brew.sh/formula/lsd#default
    
    alternative of "ls". lsd: ls Deluxe
    Developed in Rust.

    config file location: $HOME/.config/lsd/config.yaml
        You may require 🧮 mkdir -p ~/.config/lsd
'
brew install lsd

# Define alias for 'll' in an interactive session
set unique_comment "# Add ll alias for lsd"
set ll_function (echo "
    function ll
        lsd -l \$argv
    end
" | prettify_indent_via_pipe | string split0)

# Call the function to update the config
update_fish_interactive_block --unique-comment="$unique_comment" --contents="$ll_function"



: '
📦🚀 ripgrep (rg) ; https://github.com/BurntSushi/ripgrep
    https://repology.org/project/ripgrep/versions
    https://formulae.brew.sh/formula/ripgrep#default
    
    alternative of "grep".
    Developed in Rust.

    🛍️ Usage e.g. %shell>
        procs | rg "kworker"
        rg --type-list
'
brew install ripgrep


: '
📦🚀 procs ; https://github.com/dalance/procs
    https://repology.org/project/procs/versions
    https://formulae.brew.sh/formula/procs#default
    
    alternative of "ps".
    Developed in Rust.

    🛍️ Usage e.g. %shell>
        # Search by non-numeric keyword
        #    If you add any keyword as argument, it is matched to USER, Command by default.
        procs $USER --watch
        procs --tree
'
brew install procs


: '
📦🚀 jaq (Just Another Query) ; https://github.com/01mf02/jaq
    https://repology.org/project/jaq/versions
    https://formulae.brew.sh/formula/jaq#default
    
    alternative of "jq" (JSON Query).
    Developed in Rust.

    JQ clone focussed on correctness, speed, and simplicity
'
brew install jaq


: '
📦 prettier
    https://repology.org/project/prettier/versions
    https://formulae.brew.sh/formula/prettier#default

    Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML
'
brew install prettier



: '
📦 viu: A small command-line application to view images from the terminal written in Rust.
    https://github.com/atanunq/viu
    https://repology.org/project/viu/versions
    https://formulae.brew.sh/formula/viu#default

    Developed in Rust.

    🛍️ Usage e.g. %shell> 
        viu image.png
'
brew install viu





echo "▶️  Installing C/++ tools ..."
: '
📦 cmake
    https://repology.org/project/cmake/versions
    https://formulae.brew.sh/formula/cmake#default
    ==> Caveats
    To install the CMake documentation, run:
        brew install cmake-docs
📦 ninja
    https://repology.org/project/ninja/versions
    https://formulae.brew.sh/formula/ninja#default
'
brew install cmake ninja



: '
📦 gcc
    https://repology.org/project/gcc/versions
    https://formulae.brew.sh/formula/gcc#default
    
    🚣 To ensure compatibility across projects, install GCC alongside LLVM.
    
    %shell> brew deps gcc
      binutils
      glibc
      gmp
      isl
      libmpc
      lz4
      mpfr
      xz
      zlib
      zstd
    

      ❔⚠️ about glibc
        glibc
          https://repology.org/project/glibc/versions
          https://formulae.brew.sh/formula/glibc#default

        The GNU C Library
        ==> Caveats
        The Homebrew\'s Glibc has been installed with the following executables:
          /home/linuxbrew/.linuxbrew/opt/glibc/bin/ldd
          /home/linuxbrew/.linuxbrew/opt/glibc/bin/ld.so
          /home/linuxbrew/.linuxbrew/opt/glibc/sbin/ldconfig
    
        By default, Homebrew\'s linker will not search for the system\'s libraries. If you
        want Homebrew to do so, run:
    
          cp "/home/linuxbrew/.linuxbrew/etc/ld.so.conf.d/99-system-ld.so.conf.example" "/home/linuxbrew/.linuxbrew/etc/ld.so.conf.d/99-system-ld.so.conf"
          brew postinstall glibc
    
        to append the system libraries to Homebrew\'s ld search paths. This is risky and
        **highly not recommended**, because it may cause linkage to Homebrew libraries
        mixed with system libraries.
    
        glibc is keg-only, which means it was not symlinked into /home/linuxbrew/.linuxbrew,
        because it can shadow system glibc if linked.
    
        If you need to have glibc first in your PATH, run:
          echo \'export PATH="/home/linuxbrew/.linuxbrew/opt/glibc/bin:$PATH"\' >> /home/wbfw109v2/.bash_profile
          echo \'export PATH="/home/linuxbrew/.linuxbrew/opt/glibc/sbin:$PATH"\' >> /home/wbfw109v2/.bash_profile
    
        For compilers to find glibc you may need to set:
          export LDFLAGS="-L/home/linuxbrew/.linuxbrew/opt/glibc/lib"
          export CPPFLAGS="-I/home/linuxbrew/.linuxbrew/opt/glibc/include"

      
        📝 glibc version by Homebrew is lower than the Ubuntu default libc6 package 📅 2024-12-23 14:28:10
          ➡️ It is better to use the default libc6 (glibc) installed by Ubuntu.

          %shell> dpkg -s libc6 | grep -e "Version" -e "Priority"
            Priority: required
            Version: 2.39-0ubuntu8.3
            
          %shell> brew info glibc | grep glibc:
            ==> glibc: stable 2.35 (bottled) | gr


          Additionally, even if you export the Homebrew glibc, ⚠️ do not register it in FISH_CONFIG_PATH.
          If you do, it may cause errors.
            🛍️ Example error:
              When building (make command) the Raspberry Pi kernel source (https://github.com/raspberrypi/linux) with any options,
                collect2: error: ld returned 1 exit status 
                make[2]: *** [scripts/Makefile.host:114: scripts/sorttable] Error 1
                /home/linuxbrew/.linuxbrew/opt/binutils/bin/ld: /usr/libexec/gcc/x86_64-linux-gnu/13/liblto_plugin.so: error loading plugin: /home/linuxbrew/.linuxbrew/opt/glibc/lib/libc.so.6: version \`GLIBC_2.38\' not found (required by /usr/libexec/gcc/x86_64-linux-gnu/13/liblto_plugin.so)
'
brew install gcc





: '
📦 llvm, lld
https://repology.org/project/llvm/versions
https://formulae.brew.sh/formula/llvm#default
https://formulae.brew.sh/formula/lld#default
lld
a fast and lightweight linker for building projects efficiently
'
brew install llvm lld
# It includes clang, lld, lldb, and various LLVM tools for building, linking, and debugging software.
# from message 'LLD is now provided in a separate formula: '
echo "❔ You can check the list of binaries with the command 🧮 'ls /home/linuxbrew/.linuxbrew/opt/llvm/bin/'"
# CLANG_CONFIG_FILE_SYSTEM_DIR: /home/linuxbrew/.linuxbrew/etc/clang
# CLANG_CONFIG_FILE_USER_DIR:   ~/.config/clang
# Emacs Lisp files have been installed to:
#   /home/linuxbrew/.linuxbrew/share/emacs/site-lisp/llvm
# We plan to build LLVM 20 with `LLVM_ENABLE_EH=OFF`. Please see:
#   https://github.com/orgs/Homebrew/discussions/5654

: '
📦 compiledb
https://github.com/nickdiego/compiledb
https://repology.org/project/compiledb/versions
https://formulae.brew.sh/formula/compiledb#default

Generate a Clang compilation database for Make-based build systems

Refer to 🔗 _about/about-intellisense_for_c_cpp.md

🛍️ e.g. It is used for IntelliSense in the kernel build by the Makefile.
'
brew install compiledb






echo "▶️  Installing packages closedly related with Terminal-based eidtor ..."
: '
📦 helix
Terminal-based editor: Helix (hx)
🔗 https://docs.helix-editor.com/package-managers.html 📅 2024-11-05 15:18:43
https://repology.org/project/helix-editor/versions
https://formulae.brew.sh/formula/helix#default
⌨️ https://docs.helix-editor.com/keymap.html
'
brew install helix

# Helix settings 🔪 Themes
mkdir -p $HOME/.config/helix/themes

echo '
# My private Theme
inherits = "dark_high_contrast"

## Override the theming for "keyword"s:
"ui.virtual.inlay-hint" = { fg = "light-gray" }
"ui.virtual.inlay-hint.parameter" = { fg = "light-gray" }
"ui.virtual.inlay-hint.type" = { fg = "light-gray" }
"ui.virtual.wrap" = "light-gray"

# 🛍️ e.g. "keyword" = { fg = "gold" }

## Override colors in the palette:
# [palette]
# 🛍️ e.g. berry = "#2A2A4D"
' | prettify_indent_via_pipe | tee $HOME/.config/helix/themes/dark_high_contrast_modified.toml >/dev/null

# Helix settings 🔪 Languages
echo '
## https://docs.helix-editor.com/languages.html#languagestoml-files
# C/C++ settings
[[language]]
name = "c"
auto-format = true
formatter = { command = "clang-format" }

[[language]]
name = "cpp"
auto-format = true
formatter = { command = "clang-format" }
' | prettify_indent_via_pipe | tee $HOME/.config/helix/languages.toml >/dev/null

# Helix settings 🔪 Configuration
echo '
# https://docs.helix-editor.com/configuration.html
## Theme settings
# ⚓ Helix Theme index ; https://github.com/helix-editor/helix/wiki/Themes
# https://docs.helix-editor.com/themes.html
# https://github.com/helix-editor/helix/tree/master/runtime/themes
theme = "dark_high_contrast_modified"

## Editors
[editor]
lsp.display-inlay-hints = true
' | prettify_indent_via_pipe | tee $HOME/.config/helix/config.toml >/dev/null

echo "❔ hx --health c"
hx --health c
echo -e "\n❔ hx --health cpp"
hx --health cpp





echo "▶️  Installing tools for version management and dependency resolution"
: '
📦 pipx
https://repology.org/project/pipx/versions
https://formulae.brew.sh/formula/pipx#default
'
brew install pipx
pipx ensurepath

## %shell> pipx completions
# If you encountered register-python-argcomplete command not found error,
# or if you are using zipapp, run
pipx install argcomplete

# Not required to be in the config file, only run once
register-python-argcomplete --shell fish pipx >$FISH_COMPLETIONS_DIR/pipx.fish


: '
📦 pyenv
https://repology.org/project/pyenv/versions
https://formulae.brew.sh/formula/pyenv#default
'
brew install pyenv
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin

set unique_comment '## [pyenv] settings'
if not grep -Fxq "$unique_comment" "$FISH_CONFIG_PATH"
    echo "
    $unique_comment"'
pyenv init - | source
' | prettify_indent_via_pipe | tee -a $FISH_CONFIG_PATH >/dev/null
    echo -e "\n" >>"$FISH_CONFIG_PATH"
end


: '
📦 pyenv
https://repology.org/project/poetry/versions
https://formulae.brew.sh/formula/poetry#default
'
brew install poetry




: '
📦 conan
https://repology.org/project/conan/versions
https://formulae.brew.sh/formula/conan#default
'
brew install conan



: '
📦 rustup
https://repology.org/project/rustup/versions
https://formulae.brew.sh/formula/rustup#default
'
# It install cargo (Rust package manager), clippy (Rust linter), rust-docs, rust-std, rustc, rustfmt (Source code formatter)
brew install rustup
rustup default stable
# rustup is keg-only, which means it was not symlinked into /home/linuxbrew/.linuxbrew, because it conflicts with rust. If you need to have rustup first in your PATH, run:
set -U fish_user_paths /home/linuxbrew/.linuxbrew/opt/rustup/bin $fish_user_paths





echo "▶️  Installing Web-related tools ..."
: '
📦 mariadb
https://repology.org/project/mariadb/versions
https://formulae.brew.sh/formula/mariadb#default
== >Caveats
A "/etc/my.cnf" from another install may interfere with a Homebrew-built
server starting up correctly.

MySQL is configured to only allow connections from localhost by default

To start mariadb now and restart at login:
brew services start mariadb
Or, if you dont want/need a background service you can just run:
/home/linuxbrew/.linuxbrew/opt/mariadb/bin/mariadbd-safe --datadir=/home/linuxbrew/.linuxbrew/var/mysql

❔ mariadb conf file path: mariadb --help | grep my.cnf
      >> /home/linuxbrew/.linuxbrew/etc/my.cnf
❔ MariaDB uses the default character set of a database as utf8mb4 (UTF-8 multi-byte 4) when created.
This means it supports the full range of Unicode characters, including emojis and special symbols.
You can check the default character set using: 🧮 SHOW VARIABLES LIKE character_set_server
'

brew install mariadb
set homebrew_maraidb_service_name homebrew.mariadb.service
set homebrew_maraidb_service_file_path $USER_SYSTEMD_DIR/$homebrew_maraidb_service_name

echo '
[Unit]
Description=Homebrew generated unit for mariadb

[Install]
WantedBy=default.target

[Service]
Type=simple
ExecStart=/home/linuxbrew/.linuxbrew/opt/mariadb/bin/mariadbd-safe --datadir=/home/linuxbrew/.linuxbrew/var/mysql
Restart=always
WorkingDirectory=/home/linuxbrew/.linuxbrew/var
' | prettify_indent_via_pipe | tee $homebrew_maraidb_service_file_path >/dev/null
# systemctl --user daemon-reload
systemctl --user enable $homebrew_maraidb_service_name
systemctl --user start $homebrew_maraidb_service_name
systemctl --user status $homebrew_maraidb_service_name --no-pager


# from "select host, user, password from user;", "invalid" is a placeholder indicating that no password is set for the user. so I set these:
set mariadb_root_password root
set current_user_dev "$current_user"_dev
mariadb -u $current_user -D mysql --execute="
    SELECT User, Host, plugin FROM mysql.user;

    ALTER USER '$current_user'@'localhost' IDENTIFIED VIA unix_socket;
    ALTER USER 'root'@'localhost' IDENTIFIED BY '$mariadb_root_password';

    CREATE USER IF NOT EXISTS '$current_user_dev'@'%' IDENTIFIED BY '$current_user_dev';
    GRANT ALL PRIVILEGES ON *.* TO '$current_user_dev'@'%';
    
    CREATE USER IF NOT EXISTS '$current_user_dev'@'localhost' IDENTIFIED BY '$current_user_dev';
    GRANT ALL PRIVILEGES ON *.* TO '$current_user_dev'@'localhost';

    FLUSH PRIVILEGES;
    SELECT User, Host, plugin FROM mysql.user;
"
# If you set with 'IDENTIFIED VIA unix_socket',
#   - The account will use the Unix Socket plugin for authentication.
#   - This means the system user (OS username) must match the MariaDB username.
#   - Passwords will not be required or used for login as the plugin bypasses password checks.
# %mariadb> SHOW PLUGINS; -- ensure the unix_socket plugin is enabled.
# %shell> mariadb-admin -u $USER

: '
📦 mariadb-connector-c
https://repology.org/project/mariadb-connector-c/versions
https://formulae.brew.sh/formula/mariadb-connector-c#default
== >mariadb-connector-c
mariadb-connector-c is keg-only, which means it was not symlinked into /home/linuxbrew/.linuxbrew,
because it conflicts with mariadb.

If you need to have mariadb-connector-c first in your PATH, run:
echo \'export PATH="/home/linuxbrew/.linuxbrew/opt/mariadb-connector-c/bin:$PATH"\' >>/home/wbfw109/.bash_profile

For compilers to find mariadb-connector-c you may need to set:
export LDFLAGS="-L/home/linuxbrew/.linuxbrew/opt/mariadb-connector-c/lib"
export CPPFLAGS="-I/home/linuxbrew/.linuxbrew/opt/mariadb-connector-c/include"
'
brew install mariadb-connector-c
# Define and add settings for mariadb-connector-c
set unique_comment "## [mariadb-connector-c] add binary dir to path"
if not grep -Fxq "$unique_comment" "$FISH_CONFIG_PATH"
    echo "
    $unique_comment
    fish_add_path /home/linuxbrew/.linuxbrew/opt/mariadb-connector-c/bin
    set -gx LDFLAGS \$LDFLAGS -L/home/linuxbrew/.linuxbrew/opt/mariadb-connector-c/lib
    set -gx CPPFLAGS \$CPPFLAGS -I/home/linuxbrew/.linuxbrew/opt/mariadb-connector-c/include
    " | prettify_indent_via_pipe | tee -a $FISH_CONFIG_PATH >/dev/null
    echo -e "\n" >>"$FISH_CONFIG_PATH"
end






: '
📦 httpd (apache)
https://repology.org/project/httpd/versions
https://formulae.brew.sh/formula/httpd#default
== >Caveats
DocumentRoot is /home/linuxbrew/.linuxbrew/var/www.

The default ports have been set in /home/linuxbrew/.linuxbrew/etc/httpd/httpd.conf to 8080 and in
/home/linuxbrew/.linuxbrew/etc/httpd/extra/httpd-ssl.conf to 8443 so that httpd can run without sudo.

To start httpd now and restart at login:
brew services start httpd
Or, if you don\'t want/need a background service you can just run:
/home/linuxbrew/.linuxbrew/opt/httpd/bin/httpd -D FOREGROUND

❔ Error log location: /home/linuxbrew/.linuxbrew/var/log/httpd/error_log
'
brew install httpd
set homebrew_httpd_service_name homebrew.httpd.service


# Define the path to the httpd.conf file
set apache_config_file_path "/home/linuxbrew/.linuxbrew/etc/httpd/httpd.conf"


# Update the User directive in the httpd.conf file
# Replace any line starting with "User" to "User <current_user>"
# Replace any line starting with "Group" to "Group <current_user>"
sed -i "s/^User .*/User $current_user/" $apache_config_file_path
sed -i "s/^Group .*/Group $current_user/" $apache_config_file_path
echo "Updated $apache_config_file_path: User and Group set to $current_user"

brew services start httpd --debug
systemctl --user status $homebrew_httpd_service_name --no-pager
# /home/linuxbrew/.linuxbrew/var/www/index.html

## add User FileMatch blcok. inspired from STM 32 IDE
# Define the unique start and end comments for FilesMatch block
set filesmatch_start "### ⚙️ FilesMatch block - Start"
set filesmatch_end "### FilesMatch block - End"

# Create a temporary file
set tmp_file (mktemp)

# Process the httpd.conf file to insert start and end comments
awk -v filesmatch_start="$filesmatch_start" -v filesmatch_end="$filesmatch_end" '
BEGIN { start_found = 0; end_found = 0 }

# Check if the start comment already exists
$0 ~ filesmatch_start { start_found = 1 }

# Check if the end comment already exists
$0 ~ filesmatch_end { end_found = 1 }

# Print each line as is
{ print }

# At the end of the file, add the comments if not already added
END {
        if (start_found == 0 && end_found == 0) {
            print ""
            print ""
            print filesmatch_start
            print filesmatch_end
            print ""
        }
    }
' $apache_config_file_path >$tmp_file

# Overwrite the original httpd.conf
mv $tmp_file $apache_config_file_path






: '
📦 php
https://repology.org/project/php/versions
https://formulae.brew.sh/formula/php#default
== >Caveats
== >php
To enable PHP in Apache add the following to httpd.conf and restart Apache:
LoadModule php_module /home/linuxbrew/.linuxbrew/opt/php/lib/httpd/modules/libphp.so

        < FilesMatch \.php$ >

            SetHandler application/x-httpd-php
        < /FilesMatch >


    Finally, check DirectoryIndex includes index.php
DirectoryIndex index.php index.html

The php.ini and php-fpm.ini file can be found in:
/home/linuxbrew/.linuxbrew/etc/php/8.4/

To start php now and restart at login:
brew services start php
Or, if you don\'t want/need a background service you can just run:
/home/linuxbrew/.linuxbrew/opt/php/sbin/php-fpm --nodaemoniz
🪱 php-fpm: Hypertext Preprocessor FastCGI (Common Gateway Interface) Process Manager
'
brew install php
set homebrew_php_service_name homebrew.php.service

brew services start php --debug
systemctl --user status $homebrew_php_service_name --no-pager


# Define unique comments and their corresponding settings
set php_module_unique_comment "#⚙️ Load PHP module for Apache"
set php_module "LoadModule php_module /home/linuxbrew/.linuxbrew/opt/php/lib/httpd/modules/libphp.so"

set directoryindex_unique_comment "    #⚙️ DirectoryIndex for PHP"
set directoryindex_block "    #⚙️ DirectoryIndex for PHP\n    DirectoryIndex index.php index.html"

# Create a temporary file
set tmp_file (mktemp)

# Process the httpd.conf file with unique comments
awk -v php_module_unique_comment="$php_module_unique_comment" -v php_module="$php_module" \
    -v directoryindex_unique_comment="$directoryindex_unique_comment" -v directoryindex_block="$directoryindex_block" '
BEGIN { module_added = 0; directoryindex_added = 0; }

# Check if the PHP module unique comment already exists
$0 ~ php_module_unique_comment { module_added = 1 }

# Add PHP module before the first LoadModule directive, if not already added
$0 ~ /^#?LoadModule/ && module_added == 0 {
        print php_module_unique_comment
        print php_module
        module_added = 1
    }

# Check if the DirectoryIndex unique comment already exists
$0 ~ directoryindex_unique_comment { directoryindex_added = 1 }

# Comment out any existing "DirectoryIndex index.html"
/^[[:space:]]*DirectoryIndex index\.html.*$/ {
        # Define regex to capture leading spaces and the rest of the line
        regex = "^([[:space:]]*)(DirectoryIndex index.html.*)$"
        
        # Match and capture groups
        if (match($0, regex, matches)) {
            # matches[1] contains leading spaces
            # matches[2] contains the rest of the line
            print matches[1] "# " matches[2]
        } else {
            # Fallback to comment the entire line if regex fails
            print "#" $0
        }
        next
    }

# Add DirectoryIndex block inside <IfModule dir_module>
/ <IfModule dir_module >/ { in_ifmodule_dir = 1 }
in_ifmodule_dir && / <\/IfModule >/ && directoryindex_added == 0 {
        # Ensure DirectoryIndex block is added before the closing tag
        print directoryindex_block
        directoryindex_added = 1
    }
in_ifmodule_dir && / <\/IfModule >/ { in_ifmodule_dir = 0 }

# Print the original line
{ print }
' $apache_config_file_path >$tmp_file

# Overwrite the original httpd.conf
mv $tmp_file $apache_config_file_path




# Define the unique comments and settings for FilesMatch block
set filesmatch_block '<FilesMatch .php$>\n    SetHandler application/x-httpd-php\n</FilesMatch>\n'
set filesmatch_unique_comment "## FilesMatch block for PHP"

# Create a temporary file
set tmp_file (mktemp)

# Process the httpd.conf file with unique comments
awk -v filesmatch_start="$filesmatch_start" -v filesmatch_end="$filesmatch_end" \
    -v filesmatch_unique_comment="$filesmatch_unique_comment" -v filesmatch_block="$filesmatch_block" '
BEGIN { filesmatch_added = 0; in_filesmatch_block = 0 }

# Check if the unique comment for FilesMatch block already exists
$0 ~ filesmatch_unique_comment { filesmatch_added = 1 }

# Detect start of the FilesMatch block
$0 ~ filesmatch_start { in_filesmatch_block = 1 }

# Detect end of the FilesMatch block
$0 ~ filesmatch_end {
        if (in_filesmatch_block && filesmatch_added == 0) {
            # Insert FilesMatch block before the end comment
            print filesmatch_unique_comment
            print filesmatch_block
            filesmatch_added = 1
        }
        in_filesmatch_block = 0
    }

# Print the original line
{ print }
' $apache_config_file_path >$tmp_file

# Overwrite the original httpd.conf
mv $tmp_file $apache_config_file_path


: '
📦 phpmyadmin
https://repology.org/project/phpmyadmin/versions
https://formulae.brew.sh/formula/phpmyadmin#default

== >Caveats
To enable phpMyAdmin in Apache, add the following to httpd.conf and
restart Apache:
Alias /phpmyadmin /home/linuxbrew/.linuxbrew/share/phpmyadmin
        < Directory /home/linuxbrew/.linuxbrew/share/phpmyadmin/ >

            Options Indexes FollowSymLinks MultiViews
AllowOverride All
            < IfModule mod_authz_core.c >

                Require all granted
            < /IfModule >

            < IfModule !mod_authz_core.c >

                Order allow,deny
Allow from all
            < /IfModule >

        < /Directory >

    Then open http://localhost/phpmyadmin
The configuration file is /home/linuxbrew/.linuxbrew/etc/phpmyadmin.config.inc.php

👁️ Check url "localhost:8080/phpmyadmin"
'
brew install phpmyadmin

## add phpMyAdmin_config_unique_comment to httpd.conf
# Define the unique comment for the phpMyAdmin configuration block
set phpMyAdmin_config_unique_comment "### ⚙️ phpMyAdmin Alias and Directory Configuration"

# Define the content for the phpMyAdmin configuration block
set config_block_content "$phpMyAdmin_config_unique_comment
Alias /phpmyadmin /home/linuxbrew/.linuxbrew/share/phpmyadmin
<Directory /home/linuxbrew/.linuxbrew/share/phpmyadmin/>
    Options Indexes FollowSymLinks MultiViews
    AllowOverride All
    <IfModule mod_authz_core.c>
        Require all granted
    </IfModule>
    <IfModule !mod_authz_core.c>
        Order allow,deny
        Allow from all
    </IfModule>
</Directory>"

# Create a temporary file
set tmp_file (mktemp)

# Process the httpd.conf file with unique comments
awk -v phpMyAdmin_config_unique_comment="$phpMyAdmin_config_unique_comment" -v config_block_content="$config_block_content" '
BEGIN { config_block_added = 0 }

# Check if the configuration block already exists
$0 ~ phpMyAdmin_config_unique_comment { config_block_added = 1 }

# Print the original line
{ print }

# At the end of the file, add the configuration block if not already added
END {
        if (config_block_added == 0) {
            print ""
            print config_block_content
        }
    }
' $apache_config_file_path >$tmp_file

# Overwrite the original httpd.conf
mv $tmp_file $apache_config_file_path







# Restart Apache to apply changes (php, phpMyAdmin)
brew services restart httpd




: '
📦 volta
the Hassle-Free JavaScript Tool Manager
https://volta.sh/
https://repology.org/project/volta-launcher/versions
https://formulae.brew.sh/formula/volta#default

Developed in Rust.
'
brew instal volta

volta install node
volta list node


# Define the unique comment line to identify the settings.
set unique_comment "## [volta] add binary dir to path"
# Check if the unique comment line exists in the configuration file.
if not grep -Fxq "$unique_comment" "$FISH_CONFIG_PATH"
    # Append the new configuration block only if the unique line is not found.
    echo "
    $unique_comment
    fish_add_path \$HOME/.volta/bin
    " | prettify_indent_via_pipe | tee -a $FISH_CONFIG_PATH >/dev/null
    echo -e "\n" >>"$FISH_CONFIG_PATH"
end






echo "▶️  Installing tools related to VM emulation and communication with connected external devices to the host ..."
: '
📦 qemu
https://repology.org/project/qemu/versions
https://formulae.brew.sh/formula/qemu#default
'
brew install qemu



: '
📦 tio (Terminal Input/Output)
A serial device I/O tool
https://github.com/tio/tio (2018) 📅 2024-12-04 13:32:00
https://repology.org/project/tio/versions
https://formulae.brew.sh/formula/tio#default
https://api.github.com/repos/tio/tio

🚣 This tool supports color output for serial connections, similar to PuTTY.
'
brew install tio
# 🛍️ e.g. %shell> tio /dev/ttyUSB0    # Default baud rate is 115200. Use this with a Raspberry Pi and a USB-to-TTL adapter.






echo "▶️  Installing tools related to Image processing ..."
: '
📦 gm
graphicsmagick
https://repology.org/project/graphicsmagick/versions
https://formulae.brew.sh/formula/graphicsmagick#default

Image processing tools collection.
GM is more efficient than ImageMagick so it gets the job done faster using fewer resources.

🛍️ e.g. Updating the Custom Boot Image on Raspberry Pi 4B
# Reduce the color palette of the image to 224 colors and save it as "puppies_logo_clut224.ppm"
gm convert -colors 224 puppies_840x480.ppm puppies_logo_clut224.ppm

# Convert the color-reduced image to ASCII PPM format and save it as "puppies_logo_clut224_ascii.ppm"
gm convert -compress none puppies_logo_clut224.ppm puppies_logo_clut224_ascii.ppm
'
brew install graphicsmagick








echo "▶️  Installing Others ..."
: '
📦 watchman
A file watching service
https://facebook.github.io/watchman/
https://repology.org/project/watchman/versions
https://formulae.brew.sh/formula/watchman#default

'
brew install watchman

set watchman_bin (which watchman)
set fish_howto_general_dir $script_dir/howto/general

## add user service: watchman_file_make_fish_utilities_executable_name.json
set watchman_service_name "watchman-fish.service"
set watchman_json_dir $script_dir/watchman
set watchman_file_make_fish_utilities_executable_name "watchman-make_fish_utilities_executable.json"

# Original JSON file path
set watchman_json_path $watchman_json_dir/$watchman_file_make_fish_utilities_executable_name
##💡 Adaptive Watch Directory Updater for Watchman 📅 2024-12-18 03:10:54

# New path to replace the second element
set new_watch_dir $fish_howto_general_dir

# Temporary file to store the updated JSON
set temp_json "/tmp/watchman-trigger-updated.json"

# Replace the second element of the JSON array using jaq
cat $watchman_json_path | jaq --arg new_watch_dir "$new_watch_dir" '.[1] = $new_watch_dir' >$temp_json

# Display the updated JSON content
echo "Updated JSON content:"
cat $temp_json

prettier --write $temp_json
mv $temp_json $watchman_json_path


## Add watchman trigger services
: '❔ Reason for Creating a Service for Watchman
- Watchman loses its watch list after a computer restart.
Creating a system service ensures that Watchman automatically restores its watch list and trigger configurations upon system boot.
'
: '❔ Reason for Using a JSON File in Watchman
- Improved readability and cleanliness:
Using a JSON file prevents the command from being polluted with escape characters
, making the configuration easier to read and maintain.
- Service execution issue with escape characters:
Even though a command with escape characters works when copied directly into the terminal
, it fails when registered as a service.
📝 Watchman expects JSON input through standard input, so it\'s crucial to use double quotes (") to comply with JSON formatting. 📅 2024-12-18 03:16:04
    By referencing a JSON file instead, this issue is avoided
    , and the configuration remains consistent and functional across environments.
'
echo "
[Unit]
Description=Watchman service for Fish utilities (User Scope)
After=network.target

[Service]
Type=oneshot

# Watch directory
ExecStartPre=$watchman_bin watch \"$fish_howto_general_dir\"

# Trigger configuration loaded from file
ExecStart=/bin/bash -c '$watchman_bin watch $fish_howto_general_dir && \\
  cat $watchman_json_path | $watchman_bin -j \\
'

ExecStop=/bin/bash -c '$watchman_bin watch-del \"$fish_howto_general_dir\"'

RemainAfterExit=yes

[Install]
WantedBy=default.target
" | tee $USER_SYSTEMD_DIR/$watchman_service_name

systemctl --user daemon-reload
systemctl --user enable $watchman_service_name
systemctl --user start $watchman_service_name
systemctl --user status $watchman_service_name --no-pager


echo "Currently set triggers for the directory: "
watchman -- trigger-list $fish_howto_general_dir
echo ""
echo "Directories currently watched by Watchman:"
watchman watch-list

set replaced_path (string replace "$HOME" "" $fish_howto_general_dir)
# Define the unique comment line to identify the settings.
set unique_comment "## fish_howto_general_dir settings"
# Check if the unique comment line exists in the configuration file.
if not grep -Fxq "$unique_comment" "$FISH_CONFIG_PATH"
    # Append the new configuration block only if the unique line is not found.
    echo "
    $unique_comment
    set -x fish_howto_general_dir \$HOME$replaced_path
    fish_add_path \$fish_howto_general_dir
    " | prettify_indent_via_pipe | tee -a $FISH_CONFIG_PATH >/dev/null
    echo -e "\n" >>"$FISH_CONFIG_PATH"
end


# ❔ You can check permissions later after install lsd
# 🧮 %shell >find . -type f -name "*.fish" -exec lsd -l {} \;
# ❔ How to recovery: 🧮 %shell >

#   watchman watch-del $fish_howto_general_dir
# find $fish_howto_general_dir -type f -name "*.fish" -exec chmod ugo-x {} \;



: '
📦 starship ; https://github.com/starship/starship
    https://repology.org/project/starship/versions
    https://formulae.brew.sh/formula/starship#default
    
    Developed in Rust.
    Cross-Shell Prompt. The minimal, blazing-fast, and infinitely customizable prompt for any shell!.

    https://starship.rs/
    https://starship.rs/guide/#%F0%9F%9A%80-installation
      🚧 Prerequsites
        Nerd Font ; Nerd Fonts ; https://www.nerdfonts.com/
    https://starship.rs/config/
      # Conditional Format Strings ; https://starship.rs/config/#conditional-format-strings
        #️⃣ status ; https://starship.rs/config/#status
'
brew install starship

echo '[status]
style = \'bg:blue\'
symbol = \'🔴\'
format = \'[\[$symbol( $status)$maybe_int(; $common_meaning$signal_name)\]]($style) \'
map_symbol = true
disabled = false
' | tee $HOME/.config/starship.toml >/dev/null

set unique_comment "## [starship] prompt initialization settings"
if not grep -Fxq "$unique_comment" "$FISH_CONFIG_PATH"
    echo "
    $unique_comment
    starship init fish | source
    " | prettify_indent_via_pipe | tee -a $FISH_CONFIG_PATH >/dev/null
    echo -e "\n" >>"$FISH_CONFIG_PATH"
end







echo "▶️  Check installed package descrptions and versions ..."
## List all homebrew packages explicitly installed by the user (without deps) ; https://apple.stackexchange.com/questions/412352/list-all-homebrew-packages-explicitly-installed-by-the-user-without-deps
#   Note: "brew leaves" command only shows top-level packages even if the user directly installs a package 📅 2024-12-25 21:43:53
#     , it might not appear in brew leaves if it is also a dependency of another package.
set brew_user_installed (brew bundle dump --file - | awk '/^brew / {gsub(/"/, "", $2); gsub(/,/, ""); print $2}')
brew desc $brew_user_installed
echo ""
brew list --versions $brew_user_installed
echo ""

echo "❔ Running Services: "
printf "%-10s %-6s %-10s %-4s %-6s %-8s %-8s %-6s %s\n" COMMAND PID USER FD TYPE DEVICE SIZE/OFF NODE NAME
for service in (brew services list | awk 'NR > 1 {print $1}')
    # list open files
    lsof -iTCP -sTCP:LISTEN | grep $service | awk '{printf "%-10s %-6s %-10s %-4s %-6s %-8s %-8s %-6s %s\n", $1, $2, $3, $4, $5, $6, $7, $8, $9}'
end












echo "🥞 Installing available stable versions from apt in fish shell ..."

## ☑️ Issue: Bug; Ubuntu VScode PlatformIO extension messages 'PlatformIO: Can not find working Python 3.6+ Interpreter' 📅 2024-11-22 14:12:31
#   https://community.platformio.org/t/ubuntu-vscode-pio-extension-install-platformio-can-not-find-working-python-3-6-interpreter/27853
sudo apt install -y python3-venv




#### Setting locale to en_US.UTF-8
: '
☑️ Issue: Error; Potential Locale Issue Causing Build/Installation Freeze 📅 2024-12-11 00:08:48
During the build or installation process like, it may freeze:
  This can happen when a specific library or script uses the locale settings to convert strings.
  If the locale is improperly configured or missing, it can result in an infinite loop.
  🛍️ e.g. This issue was specifically encountered while building OpenCV.
  
  To prevent this, set the locale to en_US.UTF-8.
'
## Define the target file
set locale_file /etc/locale.gen

# Use awk to process the file and uncomment the desired line
awk '
    {
        if ($0 == "# en_US.UTF-8 UTF-8") {
            print "en_US.UTF-8 UTF-8";  # Uncomment the target line
        } else {
            print $0;  # Keep all other lines unchanged
        }
    }
' $locale_file >/tmp/locale.gen.temp

# Replace the original file with the updated version
sudo mv /tmp/locale.gen.temp $locale_file

# Optional: Notify the user
echo "Updated $locale_file: uncommented 'en_US.UTF-8 UTF-8'"

## Create locale based on /etc/locale.gen file.
sudo locale-gen

## Check installed locales
locale -a

## Update locale 
sudo update-locale \
    LANG=en_US.UTF-8 \
    LANGUAGE= \
    LC_CTYPE=en_US.UTF-8 \
    LC_NUMERIC=en_US.UTF-8 \
    LC_TIME=en_US.UTF-8 \
    LC_COLLATE=en_US.UTF-8 \
    LC_MONETARY=en_US.UTF-8 \
    LC_MESSAGES=en_US.UTF-8 \
    LC_PAPER=en_US.UTF-8 \
    LC_NAME=en_US.UTF-8 \
    LC_ADDRESS=en_US.UTF-8 \
    LC_TELEPHONE=en_US.UTF-8 \
    LC_MEASUREMENT=en_US.UTF-8 \
    LC_IDENTIFICATION=en_US.UTF-8 \
    LC_ALL=


echo "❗ Reboot required. locale update completed."
# Check your current locale in "/etc/default/locale" or run command "locale"




#### 📦 tailscale; Tailscale is a cloud-based VPN solution that uses peer-to-peer (P2P) connections for direct communication when possible, and falls back to encrypted relay servers for seamless connectivity.
# https://tailscale.com/download/linux
curl -fsSL https://tailscale.com/install.sh | sh
echo "if the installed computer is host, run 🧮 sudo tailscale up --ssh"
echo "else if the installed computer is client, run 🧮 sudo tailscale up"

: ' ❓ Wayland Remote GUI Challenges
  Reference: https://www.reddit.com/r/archlinux/comments/18yqapk/remote_gui_administration_on_server_running/

  ❔ Summary of Issues:
    - Wayland does not use network protocols for GUI forwarding, unlike X11.
    - Relies on local memory sharing (SHM), making remote GUI forwarding difficult.
    - Native Wayland GUI forwarding is either impossible or heavily limited.

  ❔ Key Differences:
    - X11:
      * Supports network-based GUI forwarding natively via ssh -XY.
      * Centralized X server manages GUI rendering and input.
    - Wayland:
      * Uses SHM for local memory sharing.
      * Does not support ssh -XY forwarding without additional tools.

  ➡️ Recommended Solutions ; Enable X11 (via Xorg) for remote GUI management
    - Use tools like xrdp or X11 forwarding to manage GUI applications remotely.
    - X11 is necessary because Wayland lacks native support for network-based GUI forwarding.
    - Even if Xorg is stopped to switch to Xwayland, the X server automatically restarts
      , ensuring continued compatibility with X11-based solutions.
      This behavior underscores the need to rely on X11 for remote GUI operations.
'
: ' ❓ Compositor Overview
  ❔ What is a Compositor?
    - A compositor in Wayland replaces the central X server used in X11.
    - Directly manages display and input without relying on an intermediary server.
    - Renders application windows and facilitates interactions between clients and display hardware.

  ❔ Roles of a Compositor:
    1. Display Management:
      - Handles window positioning, layout, and scaling.
    2. Input Event Handling:
      - Manages input events (mouse, keyboard) and routes them to applications.
    3. GPU Rendering:
      - Uses DRI (Direct Rendering Infrastructure) for efficient graphics rendering.

  ❔ Example: KDE Plasma and KWin
    - KDE Plasma uses KWin as its default compositor.
    - Key features:
      * Full integration with KDE Plasma for rich desktop effects.
      * Supports both X11 and Wayland environments seamlessly.
      * Leverages advanced Wayland features like fractional scaling and HDR.
'
: ' Changelog
  - Patched algorithm to accommodate changes introduced in VSCode version 1.95.2, where the SSH_CONNECTION value was updated
    , and the client IP is no longer 127.0.0.1 when connecting to the SSH server from WSL2.
'
set unique_comment "## (ssh x11 forwarding) Automatically set \$DISPLAY for X11 forwarding when connected via SSH"
if not grep -Fxq "$unique_comment" "$FISH_CONFIG_PATH"
    echo "
    $unique_comment
    # 🚧 Prerequisite: refer to 🔗 'setup_xauthority.fish' whenever reboot system or restart display manager
    # Check if the shell session is initiated over SSH by verifying the presence of SSH_CLIENT
    if set --query SSH_CLIENT
        # Extract the IP address of the Tailscale device labeled 'home'
        set windows_11_client_ip (tailscale status | awk '\$2 == \"home\" {print \$1}')
        # Set and export the DISPLAY variable to enable X11 forwarding to the detected IP
        set -gx DISPLAY \$windows_11_client_ip\":0.0\"
    end
    " | prettify_indent_via_pipe | tee -a $FISH_CONFIG_PATH >/dev/null
    echo -e "\n" >>"$FISH_CONFIG_PATH"
end






echo "▶️  Distributed file system protocol"
sudo apt install -y nfs-kernel-server
sudo systemctl start nfs-kernel-server.service
### 📦 NFS server
## Reference
# Ubuntu Network File System (NFS) ; https://ubuntu.com/server/docs/network-file-system-nfs
# ⭕ Shared directory convention in RedHat ; https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/configuring_and_using_network_file_services/index#configuring-an-nfsv3-server-with-optional-nfsv4-support_deploying-an-nfs-server
#   /srv/samba                  # in server
#   /nfs                        # in server
#   /mnt/<local_mount_dir>      # in client

## Detect the active Ethernet interface and IP address
# (This captures the first active Ethernet interface's IP address)
# -o: oneline, -f: family
set INFO (ip -o -f inet addr show | awk '$2 ~ /^e/ && $3 == "inet" {print $4; exit}')
echo "Detected IP and subnet: $INFO"

# Check if any IP address was found
if not test -n "$INFO"
    echo "No active Ethernet interface with an IP address found. Skipping NFS settings configuration."
else
    # Extract the base network (e.g., 10.10.14.0/24)
    set BASE_NET (echo $INFO | awk -F'[./]' '{printf "%s.%s.%s.0/%s\n", $1, $2, $3, $5}')
    echo "Detected base network: $BASE_NET"

    # Install and start the NFS server
    echo "Installing NFS server..."
    sudo apt install -y nfs-kernel-server
    sudo systemctl start nfs-kernel-server.service
    echo "NFS server installed and started."

    # Define the target directory for NFS exports
    set TARGET_DIR /nfs
    echo "Setting up target directory: $TARGET_DIR"
    sudo mkdir -p $TARGET_DIR

    # Create a shared directory within the target directory
    set SHARED_DIR $TARGET_DIR/common
    sudo mkdir -p $SHARED_DIR
    sudo chown $USER:$USER $TARGET_DIR
    sudo chmod 700 $TARGET_DIR
    touch $SHARED_DIR/hello # Create a test file
    echo "Shared directory created: $SHARED_DIR"

    # Define the line to add to /etc/exports for NFS sharing
    #   rw: Allows the client to have read and write permissions on the NFS share
    #   sync: Ensures all file changes are synchronized to disk for data integrity
    #   subtree_check: Verifies proper sharing of subdirectories (not recommended)
    #   no_root_squash: Allows the client's root user to retain root privileges on the server
    set unique_comment "$TARGET_DIR        $BASE_NET(rw,sync,no_subtree_check,no_root_squash)"

    echo "Export line: $unique_comment"

    # Check if the line already exists in /etc/exports
    if not grep -q "$unique_comment" /etc/exports
        # Append the line if it doesn't exist
        echo "$unique_comment" | sudo tee -a /etc/exports >/dev/null
        echo "Line added to /etc/exports."
    else
        echo "Line already exists in /etc/exports."
    end

    # Export the updated NFS settings
    sudo exportfs -a
    echo "NFS export table updated."

    # Final message
    echo "NFS server setup complete. Shared directory: $TARGET_DIR"
end


exit 100

##### When not in WSL
if test $is_wsl -eq 1
    #### 📦 IDE: VS Code from https://code.visualstudio.com/docs/setup/linux 📅 2024-11-16 15:34:43
    ## ☑️ If installed from the Snap Store with the --classic option on Wayland in Kubuntu, Hangul input does not work. 📅 2024-12-28 14:22:03 If
    #   %shell> sudo snap install code --classic
    ## brew install --cask visual-studio-code
    #   >> Error: Invalid `--cask` usage: Casks do not work on Linux

    echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
    rm -f packages.microsoft.gpg
    # Then update the package cache and install the package
    sudo apt install -y apt-transport-https
    sudo apt update
    sudo apt install -y code



    #### 📦 Web browser: Microsoft Edge
    ## brew install --cask microsoft-edge
    # Error: Invalid `--cask` usage: Casks do not work on Linux
    curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/edge stable main" | sudo tee /etc/apt/sources.list.d/microsoft-edge.list >/dev/null
    sudo apt update -y; and sudo apt install -y microsoft-edge-stable
    # Ubuntu default browser settings 
    xdg-settings set default-web-browser microsoft-edge.desktop
    xdg-settings get default-web-browser






    #### 📦 File Manager: Dolphin 📅 2024-12-06 18:01:33
    # Replace Ubuntu's default Nautilus with Dolphin
    : '❔ Advantages of Dolphin File Manager compared to Nautilus
    - Dual Panel Support
      Easily manage files with a side-by-side view in dual panel mode.
    - Configurable Keyboard Shortcuts
      Allows customization of keyboard shortcuts for better efficiency and productivity.
    - Multi-Tab Support
      Open and manage multiple folders in separate tabs within a single window.
    - Tree View in "Details" Mode
      The "Details" view mode supports displaying a folder tree for hierarchical navigation.
    '
    # # ☑️ Use "apt" to install Dolphin instead of "snap". 📅 2024-12-06 19:15:12
    # #   If installed via snap, theme customization will not work.
    # #   When installed without snap, the default file manager setting is applied automatically,
    # #       and the UI aligns with the Ubuntu system theme.
    # sudo apt install -y dolphin

    # ## Set Dolphin as the default file manager
    # # xdg-mime query default inode/directory
    # #   >> org.gnome.Nautilus.desktop
    # xdg-mime default org.kde.dolphin.desktop inode/directory
    # xdg-mime query default inode/directory

    # ## Map Super+E to open the home directory
    # # 📰 Invalid in KUbuntu?
    # # dconf write /org/gnome/settings-daemon/plugins/media-keys/home "['<Super>E']"
    # # dconf read /org/gnome/settings-daemon/plugins/media-keys/home
    # # You can reset by command 'dconf reset /org/gnome/settings-daemon/plugins/media-keys/home'
    # # Alternative: gsetting not works in other Display Server Protocol like Wayland 📅 2024-12-06 18:03:05
    # #   e.g. gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"

    # ## Set Dolphin cstom shortcut keys
    # # Dolphin configuration file path
    # # 📰🧪 The configuration file does not exist until shortcut keys are manually changed after installing Dolphin.
    # set dolphin_config_file "$HOME/.local/share/kxmlgui5/dolphin/dolphinui.rc"

    # # Line to search for in Dolphin's configuration
    # set dolphin_search_name 'name="replace_location"'

    # # Line to insert/replace in Dolphin's configuration
    # set dolphin_action_line '  <Action shortcut="Alt+D" name="replace_location"/>'

    # # Temporary file for Dolphin configuration processing (use /tmp directory)
    # set dolphin_temp_file "/tmp/dolphinui.rc"

    # # Check and process the Dolphin configuration file
    # awk -v search_name="$dolphin_search_name" -v line="$dolphin_action_line" '
    # BEGIN { in_action_properties = 0; found = 0 }
    # {
    #   # Detect the start of <ActionProperties>
    #   if ($0 ~ /<ActionProperties scheme="Default">/) {
    #     in_action_properties = 1
    #   }

    #   # Detect the end of </ActionProperties>
    #   if ($0 ~ /<\/ActionProperties>/) {
    #     if (in_action_properties && !found) {
    #       # Insert the line before </ActionProperties> if not found
    #       print line
    #     }
    #     in_action_properties = 0
    #   }

    #   # If inside <ActionProperties>, check for the line
    #   if (in_action_properties && $0 ~ search_name) {
    #     # Mark that the line already exists
    #     found = 1
    #   }

    #   # Print the original line
    #   print $0
    # }' $dolphin_config_file >$dolphin_temp_file

    # # Replace the original Dolphin configuration file with the modified version
    # mv $dolphin_temp_file $dolphin_config_file

    # echo "❗ Requires restarting the Dolphin File Explorer to apply custom shortcut keys"






    #### Install 'Twemoji Mozilla' Fonts to fix problems 'Unicode characters (emojis) are black/white' and 'Extra spacing after emoji variants for Noto Coolor Fonts' in Ubuntu 🔗 https://github.com/13rac1/twemoji-color-font
    # Fonts to download and their URLs
    set -l fonts \
        "Twemoji Mozilla https://github.com/13rac1/twemoji-color-font/releases/download/v15.1.0/TwitterColorEmoji-SVGinOT-Linux-15.1.0.tar.gz"

    # Bitstream Vera font family not found. Please install it: 
    sudo apt install ttf-bitstream-vera
    # Download and install fonts
    for font_info in $fonts
        # Extract font name and URL
        set -l parts (string match -r '(.*) (http.*)' $font_info)d
        set -l font_name $parts[2]
        set -l font_url $parts[3]

        echo "Downloading $font_name..."
        set -l download_path /tmp/$font_name.tar.gz
        wget --show-progress $font_url -O $download_path

        echo "Extracting $font_name..."
        mkdir -p /tmp/$font_name

        # Handle extraction based on file extension
        if string match -r ".*\.tar\.gz" $download_path
            tar zxf $download_path -C /tmp/$font_name
        else
            echo "Unsupported file extension: $download_path"
            continue
        end

        echo "Running installer for $font_name..."
        cd /tmp/$font_name/TwitterColorEmoji-SVGinOT-Linux-15.1.0
        bash ./install.sh
        # https://github.com/13rac1/twemoji-color-font/blob/main/linux/fontconfig/46-twemoji-color.conf
        echo "Font config file is located in $HOME/.config/fontconfig/conf.d/46-twemoji-color.conf"

        ## proprocess
        # Clean up temporary files
        echo "Cleaning up temporary files for $font_name..."
        rm -rf /tmp/$font_name $download_path
        # Move to the previous directory
        cd -
    end

    #### JetBrains Mono Nerd Font
    # Written at 📅 2024-12-25 09:47:38
    # Fonts to download and their URLs
    set -l fonts \
        "JetBrainsMono Nerd Font https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip"
    # Download, extract, and install fonts
    for font_info in $fonts
        # Extract font name and URL
        # Split the string into two parts: before and after "http"
        set -l parts (string match -r '(.*) (http.*)' $font_info)
        set -l font_name $parts[2]
        set -l font_url $parts[3]

        # Determine file extension (extract last part of URL after '.')
        set -l file_extension (echo $font_url | awk -F. '{print $NF}')

        echo "Downloading $font_name..."
        set -l download_path /tmp/$font_name.$file_extension
        wget --show-progress $font_url -O $download_path

        echo "Extracting $font_name..."
        mkdir -p /tmp/$font_name

        # Handle extraction based on file extension
        if test $file_extension = "tar.xz"
            tar -xf $download_path -C /tmp/$font_name
        else if test $file_extension = zip
            unzip -q $download_path -d /tmp/$font_name
        else
            echo "Unsupported file extension: $file_extension"
            continue
        end

        echo "Installing $font_name..."
        mkdir -p $font_dir
        find /tmp/$font_name \( -name '*.ttf' -o -name '*.otf' \) -exec cp {} $font_dir \;

        # Clean up temporary files
        rm -rf /tmp/$font_name $download_path
    end
    # Update the font cache
    echo "Updating font cache..."
    fc-cache -f $font_dir

    echo "All fonts installed successfully!"
    fc-list | grep -i nerd | awk -F: '{print $2}' | awk -F, '{print $1}' | sort | uniq

    echo "Update GNOME desktop font settings to use JetBrainsMono Nerd Font Mono..."
    # gsettings set org.gnome.desktop.interface font-name 'JetBrainsMono Nerd Font Mono'
    # gsettings set org.gnome.desktop.interface document-font-name 'JetBrainsMono Nerd Font Mono'
    # gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font Mono'

    echo "❗ Font installation complete. Please reboot to apply the font correctly."



    echo "▶️  Snap packages (Most are installed with '--classic')"






    ### 📦 (Verified) Android Studio ; https://snapcraft.io/android-studio
    sudo snap install android-studio --channel=latest/edge --classic
    echo "Android Studio is installed"
    echo "  ❗ You need to manually install the SDK through the Android Studio GUI."
    echo "    Launch Android Studio and follow the interactive setup steps to download the necessary SDK components."

    ### 📦 (Verified) Flutter ; https://snapcraft.io/flutter
    sudo snap install flutter --channel=latest/edge --classic


    ### 📦 (Verified) PowerShell ; https://snapcraft.io/powershell
    # instllation from snap store is easy than https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu 📅 2024-11-17 17:58:55
    sudo snap install powershell --classic




    ### 📦 (Verified) FFMPEG ; https://snapcraft.io/ffmpeg 📅 2024-12-26 00:13:24
    #   ; A complete solution to record, convert and stream audio and video
    : '
    ⚠️ Note: When installing ffmpeg using Snap, it is recommended to use the Edge version.
        If the Edge version is not installed, you may encounter errors like:
            /usr/share/libdrm/amdgpu.ids: No such file or directory
            amdgpu: unknown (family_id, chip_external_rev): (146, 32)
            libGL error: failed to create dri screen
            libGL error: failed to load driver: radeonsi
        These errors can occur because the Stable version may not include the latest updates
        , or fixes for AMD GPU drivers and related hardware compatibility.
        The Edge version resolves these issues by including more recent patches.
    
    📝 Note that the Snap-installed version of ffmpeg enables GPU acceleration (check by running 🧮 ffmpeg -hwaccels)
        , ⚠️ but it cannot work with files located in the /tmp/ directory.
        This is because Snap applications are confined and have restricted access to certain system directories, including /tmp/.
    ❔ The Homebrew-installed version of ffmpeg does not utilize GPU acceleration because it is built without the necessary hardware-acceleration libraries or options by default. 📅 2024-12-25 11:29:44
    '
    sudo snap install ffmpeg --channel=latest/edge




    echo "▶️  Flatpak packages"
    ## Install Flatpak with "--user" version ; https://flatpak.org/setup/Ubuntu
    # To install Flatpak on Ubuntu 18.10 (Cosmic Cuttlefish) or later, simply run:
    sudo apt install -y flatpak

    # Add the Flathub repository
    # Flathub is the best place to get Flatpak apps. To enable it, run:
    flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    echo "❗ To complete setup, restart your system. Now all you have to do is install some apps!"



    ### 📦 (Verified) GIMP ; https://flathub.org/apps/org.gimp.GIMP 📅 2024-12-25 23:12:02
    #   ; Image editor, photo retouching, and graphic design tool
    flatpak install -y --user flathub org.gimp.GIMP
    # Define alias for 'gimp' in an interactive session
    set unique_comment "# Add alias for gimp from flatpak"
    set alias_function (echo "
        function gimp
            flatpak --user run org.gimp.GIMP \$argv
        end
    " | prettify_indent_via_pipe | string split0)

    # Call the function to update the config
    update_fish_interactive_block --unique-comment="$unique_comment" --contents="$alias_function"



    ### 📦 (Verified) Parabolic ; https://flathub.org/apps/org.nickvision.tubeconverter 📅 2024-12-25 23:45:48
    #   ; Download web video and audio
    # ❔ vs. Video Downloader ; https://flathub.org/apps/com.github.unrud.VideoDownloader
    #   Both are based on 🪱 yt-dlp and support similar features, but Parabolic supports subtitle download via GUI, while Video Downloader does not.
    #     Parabolic allows for choosing video/audio formats and qualities, while Video Downloader also offers format selection but is less flexible in quality options.
    #     Parabolic provides metadata and subtitle downloads, while Video Downloader mainly focuses on video and audio downloads.
    #     Parabolic supports playlist downloads, providing more flexibility for bulk downloads, while Video Downloader focuses on single video downloads.
    #   Parabolic is more suitable for advanced users who need fine control over downloads, while Video Downloader is more streamlined for quick use.
    # ⚓ yt-dlp ; https://github.com/yt-dlp/yt-dlp
    #   ; yt-dlp is a feature-rich command-line audio/video downloader with support for thousands of sites. The
    flatpak install -y --user flathub org.nickvision.tubeconverter
    # Define alias for 'parabolic' in an interactive session
    set unique_comment "# Add alias for parabolic from flatpak"
    set alias_function (echo "
        function parabolic
            flatpak --user run org.nickvision.tubeconverter \$argv
        end
    " | prettify_indent_via_pipe | string split0)

    # Call the function to update the config
    update_fish_interactive_block --unique-comment="$unique_comment" --contents="$alias_function"



    ### 📦 (Verified) PeaZip ; https://flathub.org/apps/io.github.peazip.PeaZip 📅 2024-12-25 23:54:11
    #   ; Free file archiver utility
    ## 🚣 Use PeaZip instead of the default Ark in Kubuntu if more advanced features are required.
    flatpak install -y --user flathub io.github.peazip.PeaZip
    # Define alias for 'peazip' in an interactive session
    set unique_comment "# Add alias for peazip from flatpak"
    set alias_function (echo "
        function peazip
            flatpak --user run io.github.peazip.PeaZip \$argv
        end
    " | prettify_indent_via_pipe | string split0)

    # Call the function to update the config
    update_fish_interactive_block --unique-comment="$unique_comment" --contents="$alias_function"



    ### 📦 (Verified) ONLYOFFICE Desktop Editors ; https://flathub.org/apps/org.onlyoffice.desktopeditors 📅 2024-12-25 23:54:11
    #   ; Office productivity suite
    flatpak install -y --user flathub org.onlyoffice.desktopeditors
    # Define alias for 'onlyoffice' in an interactive session
    set unique_comment "# Add alias for onlyoffice from flatpak"
    set alias_function (echo "
        function onlyoffice
            flatpak --user run org.onlyoffice.desktopeditors \$argv
        end
    " | prettify_indent_via_pipe | string split0)

    # Call the function to update the config
    update_fish_interactive_block --unique-comment="$unique_comment" --contents="$alias_function"



    ### 📦 (Verified) WezTerm ; https://flathub.org/apps/org.wezfurlong.wezterm 📅 2024-12-25 23:54:11
    #   ; Powerful terminal and multiplexer
    flatpak install -y --user flathub org.wezfurlong.wezterm
    # Define alias for 'wezterm' in an interactive session
    set unique_comment "# Add alias for wezterm from flatpak"
    set alias_function (echo "
        function wezterm
            flatpak --user run org.wezfurlong.wezterm \$argv
        end
    " | prettify_indent_via_pipe | string split0)

    # Call the function to update the config
    update_fish_interactive_block --unique-comment="$unique_comment" --contents="$alias_function"



    echo "❔ [Flatpak] Installed user-scoped apps"
    flatpak list --user --app



end





: '❔ C++ Exception Handling Overview from "brew install llvm lld" 📅 2024-11-16 15:13:17
  What is C++ Exception Handling?
    - Mechanism to handle errors using `try`, `catch`, and `throw`.
    - Allows graceful recovery from unexpected runtime errors.
    - Improves code readability and maintainability.

  When is C++ Exception Handling commonly used? (✅)
    - General-purpose applications:
      - Desktop applications, servers, and games.
      - Provides clear separation of error-handling logic.
    - Example:
      ```
      try {
        throw std::runtime_error("Something went wrong!");
      } catch (const std::exception& e) {
        std::cout << "Caught exception: " << e.what() << std::endl;
      }
      ```
    - Easier to integrate with libraries that also use exceptions.

  When is C++ Exception Handling avoided? (⭕)
    - Embedded systems:
      - Resource-constrained environments (e.g., IoT, microcontrollers).
      - Avoids runtime overhead and reduces binary size.
    - High-performance systems:
      - Real-time systems, game engines, and HPC projects.
      - Minimizes performance overhead by using return codes instead.
    - Coding style preference:
      - Some teams prefer explicit error handling for better visibility.

    - Example (return codes):
      ```
      int divide(int a, int b, int& result) {
        if (b == 0) return -1; // Error code
        result = a / b;
        return 0;
      }

      int main() {
        int result;
        if (divide(10, 0, result) == -1) {
          std::cout << "Error: Division by zero" << std::endl;
        }
      }
      ```

  Why disable exception handling in LLVM? (⭕)
    - LLVM focuses on performance and binary size.
    - Disabling exception handling:
      - Reduces runtime overhead.
      - Minimizes LLVM’s build size and complexity.
    - LLVM projects often use explicit error codes instead of exceptions.

  Recommendation for optimization:
    - ✅ Use exception handling for general applications where clarity and ease of error management matter.
    - ⭕ Avoid exceptions in resource-constrained or high-performance projects.
      - Use return codes or state-based error handling for better control.

  Conclusion
    - C++ exceptions are powerful but not always necessary.
    - Choose based on the environment and project needs:
      - For clarity and maintainability, enable exceptions.
      - For performance-critical or constrained environments, disable them.

'

: '❔ Why do try, catch, and throw consume resources? from "brew install llvm lld" 📅 2024-11-16 15:13:17
  1. Stack Unwinding:
    - When an exception occurs, the stack frames are unwound to locate a suitable catch block.
    - Destructors for all objects in the stack are called during this process.
    - This involves 🪱 unwinding the stack, where all functions up to the exception point are removed from the stack.

  2. Runtime Data Structures:
    - Exception handling relies on runtime-generated exception tables.
    - These tables increase binary size and add lookup overhead.
    - 🪱 Runtime exception tables define how to handle exceptions for each function, adding additional metadata to the program.

  3. Exception Dispatch Overhead:
    - Exceptions disrupt the normal control flow of the program.
    - Handling exceptions requires additional CPU cycles.

  4. Optimization Limitations:
    - Compiler optimizations like inlining may be restricted in the presence of exception handling.
    - This can reduce overall performance.

'



: '
🚨 Systemd Non-POSIX Quoting Issues: Handling Escapes in Homebrew Services 📅 2024-12-02 02:03:58
  Root Cause
    Systemd uses its own (non-POSIX) syntax, conflicting with Homebrew POSIX-based escape handling. Backslashes processed by Homebrew for POSIX shells cause errors in systemd. The issue is not WSL-specific and occurs on native Ubuntu as well.
  Workaround
    - ❗ Do not use `homebrew services start <service_name> --debug`  
      Reason: This command regenerates the service file with incorrect escape characters.  
      🛍️ e.g. `ExecStart=/home/linuxbrew/.linuxbrew/opt/mariadb/bin/mariadbd-safe --datadir\=/home/linuxbrew/.linuxbrew/var/mysql`
    - and, manually edit .service files to fix quoting or use environment variables to pass arguments.
      🛍️ e.g. `ExecStart=/home/linuxbrew/.linuxbrew/opt/mariadb/bin/mariadbd-safe --datadir=/home/linuxbrew/.linuxbrew/var/mysql`


  Reference
    for "mariadb" package ; https://github.com/Homebrew/brew/issues/18236?utm_source=chatgpt.com
    for "nginx" https://github.com/Homebrew/homebrew-core/pull/195649
    for "podman" package ; https://github.com/Homebrew/brew/issues/18802
'


##### Custom commands for packages that need to specify release versions, etc.
#### Install Korean IME (Input Method Editor) 📅 2024-12-03 19:55:28
# # Set temporary directory path
# set tmp_dir /tmp
# set kime_deb_filename $tmp_dir/kime_ubuntu-22.04.deb

# # Check if kime package is already installed
# if not dpkg-query --status kime >/dev/null 2>&1
#     # If kime is not installed, download the package
#     echo "Downloading kime package..."
#     wget -O $kime_deb_filename https://github.com/Riey/kime/releases/download/v3.1.1/kime_ubuntu-22.04_v3.1.1_amd64.deb

#     # Install the package
#     echo "Installing kime package..."
#     sudo dpkg -i $kime_deb_filename

#     # No need to manually remove the .deb file, as /tmp is automatically cleaned
# else
#     echo "kime is already installed."
# end

# # Set kime as the input method using im-config
# echo "Setting kime as the input method..."
# im-config -n kime

# echo "❗ Reboot is required for the changes to take effect."


# echo "# For integration with VSCode's 'python.defaultInterpreterPath' key-value" >>"$FISH_CONFIG_PATH"
# echo "set PYTHON_POETRY_BASE_EXECUTABLE (which python3)" >>"$FISH_CONFIG_PATH"

# # #### Privacy setting .. TODO: make as function
# # git config --global user.name "wbfw109v2"
# # git config --global user.email "wbfw109v2@gmail.com"
# # git remote add origin https://github.com/lovelyPuppies/synergy-hub.git


#### 📰⚓ Windows Default Keybindings
# https://marketplace.visualstudio.com/items?itemName=smcpeak.default-keys-windows
