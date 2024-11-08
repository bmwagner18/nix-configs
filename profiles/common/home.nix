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
    # (./. + "../../../user/wm"+("/"+userSettings.wm)+".nix")
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
    # Games
    prismlauncher

    # Core
    firefox
    joplin-desktop
    vscode
    # betterbird
    protonmail-bridge-gui
    joplin

    # Terminal
    alacritty
    lazygit
    alejandra

    # Office
    libreoffice-fresh
    nextcloud-client

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
    colmena
  ];

  news.display = "silent";
}
