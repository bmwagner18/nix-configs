{ ... }: {

# Since autostart is disabled, the VPN must be manually started and stopped via:
# sudo systemctl start wg-quick-home.service
# sudo systemclt stop wg-quick-home.service

imports = [ ../../secrets/sops.nix ];

sops.secrets.home_wireguard_config= {};

networking.wg-quick.interfaces = {
    home = {
      configFile = "/run/secrets/home_wireguard_config";
      autostart = false;
    };
  };
}
