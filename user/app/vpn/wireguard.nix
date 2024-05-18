# Enable wireguard tunnel to my apartment via wg-quick
  # networking.wg-quick.interfaces = {
  #   wg0 = {
  #     address = ["172.16.16.2/32"];
  #     dns = ["192.168.35.5"];
  #     privateKeyFile = "/home/ben/wireguard-keys/privatekey";
  #     peers = [
  #       {
  #         publicKey = "fZOk0DLcPQfphOuU5LPYU5fOvD0WGyoH9+NSdoG+fwY=";
  #         presharedKeyFile = "/home/ben/wireguard-keys/presharedkey";
  #         allowedIPs = ["172.16.16.0/24" "192.168.35.0/24"];
  #         endpoint = "quesadilla.cloud:51820";
  #         persistentKeepalive = 25;
  #       }
  #     ];
  #   };
  # };