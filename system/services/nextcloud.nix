{
  self,
  config,
  lib,
  pkgs,
  userSettings,
  ...
}: {
  imports = [
    ../../secrets/sops.nix
  ];

  # Mount the truenas NFS data location
  fileSystems."/mnt/nextcloud" = {
    device = "192.168.35.20:/mnt/zues/nextcloud";
    fsType = "nfs";
    options = ["nfsvers=3"];
  };

  # Import secrets from sops
  sops.secrets.cloudflare_env = {};
  sops.secrets.nextcloud_adminpassword = {
    owner = "nextcloud";
  };

  # Based on https://carjorvaz.com/posts/the-holy-grail-nextcloud-setup-made-easy-by-nixos/
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = userSettings.email;
      dnsProvider = "cloudflare";
      # location of your CLOUDFLARE_DNS_API_TOKEN=[value]
      # https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#EnvironmentFile=
      environmentFile = "/run/secrets/cloudflare_env";
    };
  };

  services = {
    nginx.virtualHosts = {
      "nextcloud.quesadilla.cloud" = {
        forceSSL = true;
        enableACME = true;
        # Use DNS Challenege.
        acmeRoot = null;
      };
    };

    nextcloud = {
      enable = true;
      hostName = "nextcloud.quesadilla.cloud";
      # Need to manually increment with every major upgrade.
      package = pkgs.nextcloud29;
      # Let NixOS install and configure the database automatically.
      database.createLocally = true;
      # Let NixOS install and configure Redis caching automatically.
      configureRedis = true;
      # Increase the maximum file upload size.
      maxUploadSize = "16G";
      https = true;
      autoUpdateApps.enable = true;
      extraAppsEnable = true;

      # Change where the nextcloud data is stored
      # datadir = "/mnt/nextcloud";
      # datadir = "/var/lib/nextcloud";

      extraApps = with config.services.nextcloud.package.packages.apps; {
        # List of apps we want to install and are already packaged in
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
        inherit notes tasks qownnotesapi deck;
        # # Custom app example.
        # socialsharing_telegram = pkgs.fetchNextcloudApp rec {
        #   url =
        #     "https://github.com/nextcloud-releases/socialsharing/releases/download/v3.0.1/socialsharing_telegram-v3.0.1.tar.gz";
        #   license = "agpl3";
        #   sha256 = "sha256-8XyOslMmzxmX2QsVzYzIJKNw6rVWJ7uDhU1jaKJ0Q8k=";
        # };
      };

      settings = {
        overwriteprotocol = "https";
        default_phone_region = "US";
        datadirectory = "/mnt/nextcloud/";
      };

      config = {
        dbtype = "pgsql";
        adminuser = "admin";
        adminpassFile = "/run/secrets/nextcloud_adminpassword";
      };
      # Suggested by Nextcloud's health check.
      phpOptions."opcache.interned_strings_buffer" = "16";
    };
    # Nightly database backups.
    postgresqlBackup = {
      enable = true;
      startAt = "*-*-* 01:15:00";
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

}
