{
  pkgs,
  lib,
  systemSettings,
  userSettings,
  ...
}: {
  imports = [
    ../common/configuration.nix # Import common config between laptops and desktops
    ../../system/services/bluetooth.nix
    ../../system/security/mullvad-toronto.nix
    # ../../system/tui/incus.nix
    ../../system/tui/docker.nix
    ../../system/security/home-wireguard.nix
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    motrix
  ];

  system.stateVersion = "23.11";
}
