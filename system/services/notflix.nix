{pkgs, userSettings, ...}:
{
  imports = [
    ../../secrets/sops.nix
    # ../../system/services/mullvad.nix
    ./backup.nix
    ./transmission.nix
  ];

  sops.secrets.cloudflare_env = {};

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = userSettings.email;
      dnsProvider = "cloudflare";
      environmentFile = "/run/secrets/cloudflare_env";
    };
  };

  # Mount the truenas NFS data location
  fileSystems."/mnt/notflix" = {
    device = "192.168.35.20:/mnt/zues/notflix";
    fsType = "nfs";
    options = ["nfsvers=3"];
  };

  # users.groups.media.members = [ userSettings.username "transmission" "sabnzbd" "prowlarr" "radarr" "sonarr" "bazarr" "jellyfin" ];

  services = {
    nginx = {
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      virtualHosts = {
        "transmission.quesadilla.cloud" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:9091";
            recommendedProxySettings = false;
            # Undo the "recommendedProxySettings"
            extraConfig = ''
                    proxy_set_header Host $proxy_host;
                    proxy_set_header Connection close;
                    proxy_set_header X-Real-IP "";
                    proxy_set_header X-Forwarded-For "";
                    proxy_set_header X-Forwarded-Proto "";
                    proxy_set_header X-Forwarded-Host "";
                    proxy_set_header X-Forwarded-Server "";
            '';
          };
          forceSSL = true;
          enableACME = true;
          # Use DNS Challenge.
          acmeRoot = null;
        };
        "nzb.quesadilla.cloud" = {
          locations."/".proxyPass = "http://127.0.0.1:8080";
          forceSSL = true;
          enableACME = true;
          # Use DNS Challenge.
          acmeRoot = null;
        };
        "prowlarr.quesadilla.cloud" = {
          locations."/".proxyPass = "http://127.0.0.1:9696";
          forceSSL = true;
          enableACME = true;
          # Use DNS Challenge.
          acmeRoot = null;
        };
        "radarr.quesadilla.cloud" = {
          locations."/".proxyPass = "http://127.0.0.1:7878";
          forceSSL = true;
          enableACME = true;
          # Use DNS Challenge.
          acmeRoot = null;
        };
        "sonarr.quesadilla.cloud" = {
          locations."/".proxyPass = "http://127.0.0.1:8989";
          forceSSL = true;
          enableACME = true;
          # Use DNS Challenge.
          acmeRoot = null;
        };
        "bazarr.quesadilla.cloud" = {
          locations."/".proxyPass = "http://127.0.0.1:6767";
          forceSSL = true;
          enableACME = true;
          # Use DNS Challenge.
          acmeRoot = null;
        };
        "jellyfin.quesadilla.cloud" = {
          locations."/".proxyPass = "http://127.0.0.1:8096";
          forceSSL = true;
          enableACME = true;
          # Use DNS Challenge.
          acmeRoot = null;
        };
      };
    };
    # Torrent downloader

    # transmission is provided via ./transmission using docker and gluetun vpn
    # transmission = {
      # enable = true;
      # package = pkgs.transmission_4;
      # openFirewall = true;
      # openRPCPort = true;
      # webHome = pkgs.flood-for-transmission;
      #settings = {
        # download-dir = "/mnt/notflix/downloads/torrents/complete";
        # incomplete-dir = "/mnt/notflix/downloads/torrents/incomplete";
        # peer-port = 51413;
      # };
    # };
    # Usenet downloader
    sabnzbd = {
      enable = true;
      # group = "media";
    };
    # Indexer management
    prowlarr = {
      enable = true;
      # group = "media";
    };
    # Movie management
    radarr = {
      enable = true;
      # group = "media";
    };
    # TV management
    sonarr = {
      enable = true;
      # group = "media";
    };
    # Subtitles
    bazarr = {
      enable = true;
      # group = "media";
    };
    # Media streaming
    jellyfin = {
      enable = true;
      # group = "media";
    };
  };
}
