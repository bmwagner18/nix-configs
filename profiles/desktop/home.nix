{
  config,
  pkgs,
  userSettings,
  ...
}: {
  imports = [
    ../common/home.nix
    # ~/nix-configs/profiles/commmon/home.nix
  ];

  home.packages = with pkgs; [
    # qutebrowser
    yt-dlp
  ];
}
