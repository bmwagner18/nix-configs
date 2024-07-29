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
  ];

  home.stateVersion = "23.11";

  # Home Manager needs to know unfree is ok too
  nixpkgs.config.allowUnfree = true;
  # nixpkgs.allowUnfreePredicate = _: true;

  home.packages = with pkgs; [
    # Terminal
    lazygit
    alejandra
  ];

  news.display = "silent";
}
