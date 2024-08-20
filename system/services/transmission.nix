# Auto-generated using compose2nix v0.2.2-pre.
{ pkgs, lib, ... }:

{
  # Runtime
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";

  # Containers
  virtualisation.oci-containers.containers."gluetun" = {
    image = "qmcgaw/gluetun";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "SERVER_CITIES" = "Toronto";
      "TZ" = "America/New_York";
      "VPN_SERVICE_PROVIDER" = "mullvad";
      "VPN_TYPE" = "wireguard";
      "WIREGUARD_ADDRESSES" = "10.65.132.49/32";
      "WIREGUARD_PRIVATE_KEY" = "aBfBhgAfINOSU9EQ6YBNmDVr5L1uMpUdby5m1AQnMVA=";
    };
    ports = [
      "9091:9091/tcp"
      "51413:51413/tcp"
      "51413:51413/udp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--device=/dev/net/tun:/dev/net/tun"
      "--network-alias=gluetun"
      "--network=transmission_default"
    ];
  };
  systemd.services."docker-gluetun" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "docker-network-transmission_default.service"
    ];
    requires = [
      "docker-network-transmission_default.service"
    ];
    partOf = [
      "docker-compose-transmission-root.target"
    ];
    wantedBy = [
      "docker-compose-transmission-root.target"
    ];
  };
  virtualisation.oci-containers.containers."transmission" = {
    image = "lscr.io/linuxserver/transmission:latest";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    volumes = [
      "transmission_config:/config:rw"
      "transmission_data:/downloads:rw"
    ];
    dependsOn = [
      "gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:gluetun"
    ];
  };
  systemd.services."docker-transmission" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "docker-volume-transmission_config.service"
      "docker-volume-transmission_data.service"
    ];
    requires = [
      "docker-volume-transmission_config.service"
      "docker-volume-transmission_data.service"
    ];
    partOf = [
      "docker-compose-transmission-root.target"
    ];
    wantedBy = [
      "docker-compose-transmission-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-transmission_default" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f transmission_default";
    };
    script = ''
      docker network inspect transmission_default || docker network create transmission_default
    '';
    partOf = [ "docker-compose-transmission-root.target" ];
    wantedBy = [ "docker-compose-transmission-root.target" ];
  };

  # Volumes
  systemd.services."docker-volume-transmission_config" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect transmission_config || docker volume create transmission_config
    '';
    partOf = [ "docker-compose-transmission-root.target" ];
    wantedBy = [ "docker-compose-transmission-root.target" ];
  };
  systemd.services."docker-volume-transmission_data" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect transmission_data || docker volume create transmission_data
    '';
    partOf = [ "docker-compose-transmission-root.target" ];
    wantedBy = [ "docker-compose-transmission-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-transmission-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
  # Open firewall for peer connections???
  # networking.firewall.interfaces.???
}