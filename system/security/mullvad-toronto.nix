{ ... }: {

# Since autostart is disabled, the VPN must be manually started and stopped via:
# sudo systemctl start wg-quick-mullvad.service
# sudo systemclt stop wg-quick-mullvad.service

imports = [ ../../secrets/sops.nix ];

sops.secrets.mullvad_toronto_private = {};

networking.wg-quick.interfaces = {
    mullvad = {
      address = [ "10.66.241.157/32" ];
      dns = [ "10.64.0.1" ];
      privateKeyFile = "/run/secrets/mullvad_toronto_private";

      peers = [
        {
          publicKey = "ptnLZbreIzTZrSyPD0XhOAAmN194hcPSG5TI5TTiL08=";
          # presharedKeyFile = "/root/wireguard-keys/preshared_from_peer0_key";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "198.54.132.162:51820";
          persistentKeepalive = 25;
        }
      ];
      autostart = false;
    };
  };
}
