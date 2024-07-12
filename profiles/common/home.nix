{
  config,
  pkgs,
  userSettings,
  ...
}: {
  # Where Home Manager will home manage
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  # Let it manage itself
  programs.home-manager.enable = true;

  imports = [
    ../../user/shell/sh.nix # bash config
    ../../user/app/git/git.nix # git config
    # ../../user/shell/nixvim.nix
    ../../user/shell/neovim.nix
    ../../user/shell/zellij.nix
  ];

  home.stateVersion = "23.11";

  # Home Manager needs to know unfree is ok too
  nixpkgs.config.allowUnfree = true;
  # nixpkgs.allowUnfreePredicate = _: true;

  home.packages = with pkgs; [
    # Core
    firefox
    joplin-desktop
    vscode
    betterbird
    protonmail-bridge-gui

    # Terminal
    alacritty
    lazygit
    alejandra

    # Office
    libreoffice-fresh

    # Media
    jellyfin-media-player
    vlc
    obs-studio
    ffmpeg
    losslesscut-bin
    spotify
    # yt-dlp-light
    # tartube

    # Communication
    slack
    discord

    # Engineering tools
    super-slicer-latest

    # Development
    android-tools
    android-udev-rules
  ];

  news.display = "silent";
}
