{
  config,
  pkgs,
  userSettings,
  ...
}: {
  imports = [
    ../common/home.nix
    ../../user/app/browser/librewolf.nix
  ];

  home.packages = with pkgs; [
    # qutebrowser
    gimp-with-plugins
  ];
}
