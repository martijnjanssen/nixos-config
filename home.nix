{ config, pkgs, ... }:

with pkgs;
let
  my-python-packages = python-packages:
    with python-packages; [
      python-language-server
      moretools
      matplotlib
      numpy
      scipy
      tweepy
      pandas
      # other python packages you want
    ];
  python-with-my-packages = python3.withPackages my-python-packages;

  comma = import (fetchFromGitHub {
    owner = "nix-community";
    repo = "comma";
    rev = "02e3e5545b0c62595a77f3d5de1223c536af0614";
    sha256 = "0qgg632ky6bnwkf9kh1z4f12dilkmdy0xgpal26g2vv416di04jq";
  }) { };

  pkgsUnstable = import <nixpkgs-unstable> { };

in {
  targets.genericLinux.enable = true;

  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  programs.zsh = {
    enable = true;
    autosuggestion = { enable = true; };
    sessionVariables = {
      GOPATH = "$HOME/go";
      GOBIN = "${config.programs.zsh.sessionVariables.GOPATH}/bin";
      PATH =
        "$HOME/Downloads/webdsl/bin:$HOME/.cargo/bin:$HOME/.config/emacs/bin:${config.programs.zsh.sessionVariables.GOBIN}:$(yarn global bin):$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$HOME/flutter/bin:$HOME/flutter/.pub-cache/bin:$PATH";
      EDITOR = "vim";
      ANDROID_HOME = "$HOME/Android/Sdk";
      CHROME_EXECUTABLE = "$HOME/.nix-profile/bin/google-chrome-stable";
    };
    shellAliases = {
      h = "home-manager";
      bst =
        "curl -s https://api.cryptowat.ch/markets/bitstamp/xrpeur/summary | jq '.result.price'";
      up = "sudo wg-quick up wg0";
      down = "sudo wg-quick down wg0";
      dockerup = "sudo systemctl start docker";
      dockerdown = "sudo systemctl stop docker";
      web = "webdsl";
    };
    initExtra = ''
      race () {
        streamlink $1 1080p --hls-audio-select "*"
      }
    '';

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";

      plugins = [ "git" "docker" ];
    };
  };

  programs.git = {
    enable = true;
    userName = "Martijn Janssen";
    userEmail = "martijn9612+github@gmail.com";
    extraConfig = {
      pull = { rebase = "true"; };
      http = { cookieFile = "~/.gitcookies"; };
    };
  };

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [ epkgs.vterm ];
  };

  home.packages = with pkgs; [
    htop
    findutils
    tree
    jq
    silver-searcher
    ripgrep
    fd
    cmake
    comma

    vim
    gitAndTools.git-codereview

    fira-code
    fira-code-symbols

    rustup
    # pkgsUnstable.rust-analyzer
    go_1_23
    protobuf
    yarn
    nodejs
    nixfmt
    shellcheck
    docker-compose
    pkgsUnstable.fluxcd
    kubeseal

    # for react/flutter
    android-studio
    # For react
    watchman

    # for webdsl
    # ant
    # adoptopenjdk-bin
    openjdk8

    # texlive.combined.scheme-medium

    # python-with-my-packages
    # black

    spotify
    vlc
    mpv
    transmission_4-gtk
    transmission-remote-gtk
    tdesktop
    #teams

    google-chrome
    chromium

    openttd

    pulseeffects-legacy
    pkgsUnstable.gnomeExtensions.caffeine
    pkgsUnstable.gnomeExtensions.sound-output-device-chooser
    dropbox
  ];

  home.file.".ssh/config".source = dotfiles/ssh/config;

  home.file.".spacemacs".source = dotfiles/spacemacs/spacemacs;
  home.file.".doom.d/init.el".source = dotfiles/doom/init.el;
  home.file.".doom.d/config.el".source = dotfiles/doom/config.el;
  home.file.".doom.d/packages.el".source = dotfiles/doom/packages.el;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "martijn";
  home.homeDirectory = "/home/martijn";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";
}
