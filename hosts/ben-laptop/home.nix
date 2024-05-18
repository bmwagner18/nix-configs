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

  home.packages = with pkgs; [
    # Core
    firefox
    joplin-desktop
    vscode

    # Office
    # libreoffice-fresh
    # wine

    # Media
    jellyfin
    # vlc
    # obs-studio
    # ffmpeg
    # audio-recorder

    # Communication
    slack
    discord

    # Engineering tools
    super-slicer-latest
  ]

}