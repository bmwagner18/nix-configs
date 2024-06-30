{ pkgs, config, userSettings, ... }:

{
  environment.systemPackages = [ pkgs.mullvad-vpn pkgs.mullvad ];
  services.mullvad-vpn = {
    enable = true;
    # package = pkgs.mullvad-vpn;
  }
  # services.mullvad-vpn.package = pkgs.mullvad-vpn;

  # networking.nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];

  # services.resolved = {
  #   enable = true;
  #   dnssec = "true";
  #   domains = [ "~." ];
  #   fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
  #   dnsovertls = "true";
  # };

}
