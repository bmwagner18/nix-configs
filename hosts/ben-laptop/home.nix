{ config, pkgs, userSettings, ... }: {

  # Where Home Manager will home manage
  home.username = userSettings.username;
  home.homeDirectory = "/home/"+userSettings.username;

  # Let it manage itself
  programs.home-manager.enable = true;

  imports = [
    ../../user/shell/sh.nix # bash config
    ../../user/app/git/git.nix # git config
    ../../user/app/vpn/mullvad.nix
    ../../user/app/neovim/neovim.nix
  ];

  home.stateVersion = "23.11";

  # Home Manager needs to know unfree is ok too
  nixpkgs.config.allowUnfree = true;


  home.packages = with pkgs; [
    # Core
    firefox
    joplin-desktop
    vscode
    alacritty

    # Office
    libreoffice-fresh
    wine

    # Media
    jellyfin
    vlc
    obs-studio
    ffmpeg
    losslesscut-bin
    # audio-recorder

    # Communication
    slack
    discord

    # Engineering tools
    super-slicer-latest
  ];

}