{ pkgs, userSettings, ... }:
{
  environment.systemPackages = with pkgs; [ incus ];
  virtualisation.incus.enable = true;

  # Required to allow LXC contianers to get DHCP addresses
  networking.firewall.trustedInterfaces = [ "incusbr0" ];
  # Incus requires nftables
  networking.nftables.enable = true;
  users.users.${userSettings.username}.extraGroups = ["incus-admin"];
}
