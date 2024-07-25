{
  config,
  pkgs,
  ...
}: {
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  # virtualisation.virtualbox.host.enable = true;
  # users.extraGroups.vboxusers.members = [ "ben" ];
  # virtualisation.virtualbox.host.enableExtensionPack = true;

  environment.systemPackages = [
    pkgs.virtualbox
  ];
}
