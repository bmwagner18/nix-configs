
{
  pkgs,
  lib,
  systemSettings,
  userSettings,
  ...
}: {
  imports = [
    ../common/configuration.nix # Import common config between laptops and desktops
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    vim
  ];

  system.stateVersion = "23.11";
}
