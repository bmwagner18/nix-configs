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
    ../../user/tui/sh.nix # bash config
    ../../user/tui/git.nix # git config
    ../../user/tui/neovim/nixvim.nix
    # ../../user/tui/neovim.nix
    ../../user/tui/zellij.nix
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
