{ ... }:

{
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "ben" ];
  virtualisation.virtualbox.host.enableExtensionPack = true;

  environment.systemPackages = [
    pkgs.virtualbox
  ];

}
