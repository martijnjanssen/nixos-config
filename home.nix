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
    owner = "Shopify";
    repo = "comma";
    rev = "4a62ec17e20ce0e738a8e5126b4298a73903b468";
    sha256 = "0n5a3rnv9qnnsrl76kpi6dmaxmwj1mpdd2g0b4n1wfimqfaz6gi1";
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
    enableAutosuggestions = true;
    sessionVariables = {
      GOPATH = "/home/martijn/go";
      GOBIN = "${config.programs.zsh.sessionVariables.GOPATH}/bin";
      PATH =
        "$HOME/.cargo/bin:$HOME/.emacs.d/bin:${config.programs.zsh.sessionVariables.GOBIN}:$(yarn global bin):$PATH";
      EDITOR = "vim";
    };
    shellAliases = {
      bst =
        "curl -s https://api.cryptowat.ch/markets/bitstamp/xrpeur/summary | jq '.result.price'";
      up = "sudo wg-quick up wg0";
      down = "sudo wg-quick down wg0";
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
    pkgsUnstable.rust-analyzer
    go
    protobuf
    yarn
    nodejs
    texlive.combined.scheme-medium
    nixfmt
    shellcheck

    python-with-my-packages

    spotify
    streamlink
    vlc
    mpv
    transmission-gtk
    tdesktop
    teams
    google-chrome

    openttd

    gnomeExtensions.caffeine
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
