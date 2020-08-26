{ config, pkgs, ... }:

{
  targets.genericLinux.enable = true;

  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };
  };

  programs.git = {
    enable = true;
    userName = "Martijn Janssen";
    userEmail = "martijn9612+github@gmail.com";
  };

  home.packages = with pkgs; [
    htop
    mlocate
    tree

    emacs
    vim

    spotify
    vlc
    tdesktop

    openttd
  ];

  home.file.".spacemacs".source = dotfiles/spacemacs/spacemacs;

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
