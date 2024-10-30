### 📑 File in $HOME/.config/home-manager/home.nix
{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "wbfw109v2";
  home.homeDirectory = "/home/wbfw109v2";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.

  # home.activation = {
  #   installHomebrew = pkgs.lib.mkIf (config.home.sessionVariables.BREW_PREFIX == null) ''
  #     nix-shell -p curl --run "echo | /bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
  #     echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.bashrc
  #     echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.config/fish/config.fish
  #     eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  #   '';

  #   uninstallHomebrew = pkgs.lib.mkIf (config.home.sessionVariables.BREW_PREFIX != null) ''
  #     nix-shell -p curl --run "yes | /bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)\""
  #   '';
  # };

  # # 환경 변수 설정
  # home.sessionVariables = {
  #   BREW_PREFIX = "/home/linuxbrew/.linuxbrew";
  # };
  
  home.packages = [
    pkgs.curl
    # pkgs.watchman
    # pkgs.watchman
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/tools/watchman/default.nix
    # https://github.com/facebook/watchman/releases
    # nix-prefetch-url https://github.com/facebook/watchman/archive/refs/tags/v2024.11.11.00.tar.gz


    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
  

  ## 🚣 cat $HOME/.nix-profile/bin
  home.activation.testCurlHelp = ''
    echo "Testing curl command after installation:"
    ${pkgs.curl}/bin/curl --help
  '';


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/wbfw109v2/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
