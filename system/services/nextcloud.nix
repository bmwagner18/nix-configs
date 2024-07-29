{
  self,
  config,
  lib,
  pkgs,
  ...
}: {

  # Mount the truenas NFS data location
  fileSystems."/mnt/nextcloud_data" = {
    device = "192.168.35.20:/mnt/zues/nextcloud_data";
    fsType = "nfs";
    options = ["nfsvers=3"];
  };
  

  # Based on https://carjorvaz.com/posts/the-holy-grail-nextcloud-setup-made-easy-by-nixos/
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "bmwagner18@gmail.com";
      dnsProvider = "porkbun";
      # location of your CLOUDFLARE_DNS_API_TOKEN=[value]
      # https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#EnvironmentFile=
      environmentFile = "/run/secrets/nextcloud_env"
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
      package = pkgs.nextcloud28;
      # Let NixOS install and configure the database automatically.
      database.createLocally = true;
      # Let NixOS install and configure Redis caching automatically.
      configureRedis = true;
      # Increase the maximum file upload size.
      maxUploadSize = "16G";
      https = true;
      autoUpdateApps.enable = true;
      extraAppsEnable = true;

      # Change where the nextcloud database is stored
      datadir = "/var/lib/nextcloud";
      # Change where all the data is stored
      home = "/mnt/nextcloud_data";

      extraApps = with config.services.nextcloud.package.packages.apps; {
        # List of apps we want to install and are already packaged in
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
        # inherit calendar contacts notes onlyoffice tasks qownnotesapi;
        inherit qownnotesapi;
        # # Custom app example.
        # socialsharing_telegram = pkgs.fetchNextcloudApp rec {
        #   url =
        #     "https://github.com/nextcloud-releases/socialsharing/releases/download/v3.0.1/socialsharing_telegram-v3.0.1.tar.gz";
        #   license = "agpl3";
        #   sha256 = "sha256-8XyOslMmzxmX2QsVzYzIJKNw6rVWJ7uDhU1jaKJ0Q8k=";
        # };
      };
      config = {
        overwriteProtocol = "https";
        defaultPhoneRegion = "US";
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
}
