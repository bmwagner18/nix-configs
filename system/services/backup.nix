{ pkgs, userSettings, ... }:
{
  systemd.timers."copy_backups" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      unit = "copy_backups.service";
    };
  };

  systemd.services."copy_backups" = {
    script = ''
      # USERNAME=${userSettings.username}
      # USERNAME = "ben"

      ${pkgs.rsync}/bin/rsync -a -P --mkpath /var/lib/radarr/.config/Radarr/Backups/ /home/ben/backups/Radarr/Backups/
      ${pkgs.rsync}/bin/rsync -a -P --mkpath /var/lib/sonarr/.config/NzbDrone/Backups/ /home/ben/backups/Sonarr/Backups/
      ${pkgs.rsync}/bin/rsync -a -P --mkpath /var/lib/private/prowlarr/Backups/ /home/ben/backups/Prowlarr/Backups/
      ${pkgs.rsync}/bin/rsync -a -P --mkpath /var/lib/bazarr/backup/ /home/ben/backups/Prowlarr/Backups/
      ${pkgs.rsync}/bin/rsync -a -P --mkpath /var/lib/jellyfin/config/ /home/ben/backups/Jellyfin/config/
      ${pkgs.rsync}/bin/rsync -a -P --mkpath /var/lib/jellyfin/data/ /home/ben/backups/Jellyfin/data/
      ${pkgs.rsync}/bin/rsync -a -P --mkpath /var/lib/nextcloud/data/ /home/ben/backups/nextcloud/data/
      ${pkgs.rsync}/bin/rsync -a -P --mkpath /var/lib/nextcloud/config/ /home/ben/backups/nextcloud/config/
      ${pkgs.rsync}/bin/rsync -a -P --mkpath /var/backup/postgresql/ /home/ben/backups/nextcloud/postgresqlBackup/

      chown ben:users -R /home/ben/backups/
    '';
    serviceConfig = {
        Type = "oneshot";
        User = "root";
    };
  };
}
