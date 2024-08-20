{
  pkgs,
  lib,
  systemSettings,
  userSettings,
  ...
}: {
  imports = [
    ../common/configuration.nix # Import common config between laptops and desktops
    # ~/nix-configs/profiles/common/configuration.nix
    ../../system/services/bluetooth.nix
    ../../system/services/mullvad_toronto.nix
    ../../system/services/incus.nix
    ../../system/services/docker.nix
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    vim
  ];

  system.stateVersion = "23.11";
}
