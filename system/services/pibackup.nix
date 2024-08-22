{ pkgs, userSettings, ... }:
let
  myPythonEnv = pkgs.python3.withPackages (ps: with ps; [
    pyyaml
  ]);
in
{

  # Right now I'm not aware of a way to avoid installing
  environment.systemPackages = with pkgs; [ rdiff-backup ];

  # Mount the backup filesystem
  fileSystems."/mnt/backups" = {
    device = "/dev/sda";
    fsType = "btrfs";
  };

  # Systemd services used for executing the backups as instructed by backups.yaml
  systemd.services = {
    "hourly_rdiff" = {
      script = ''
        ${myPythonEnv}/bin/python3 /home/${userSettings.username}/nix-configs/scripts/rdiff-backup.py -f HOURLY -p "/home/${userSettings.username}/backups.yaml"
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "${userSettings.username}";
        Environment = "PATH=${pkgs.rdiff-backup}/bin:${myPythonEnv}/bin:${pkgs.python3}/bin:${pkgs.stdenv.cc}/bin:${pkgs.stdenv.cc}/lib";
      };
    };
    "daily_rdiff" = {
      script = ''
        ${myPythonEnv}/bin/python3 /home/${userSettings.username}/nix-configs/scripts/rdiff-backup.py -f DAILY -p "/home/ben/backups.yaml"
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "${userSettings.username}";
        Environment = "PATH=${pkgs.rdiff-backup}/bin:${myPythonEnv}/bin:${pkgs.python3}/bin:${pkgs.stdenv.cc}/bin:${pkgs.stdenv.cc}/lib";
      };
    };
    "weekly_rdiff" = {
      script = ''
        ${myPythonEnv}/bin/python3 /home/${userSettings.username}/nix-configs/scripts/rdiff-backup.py -f WEEKLY -p "/home/ben/backups.yaml"
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "${userSettings.username}";
        Environment = "PATH=${pkgs.rdiff-backup}/bin:${myPythonEnv}/bin:${pkgs.python3}/bin:${pkgs.stdenv.cc}/bin:${pkgs.stdenv.cc}/lib";
      };
    };
  };

  systemd.timers = {
    "hourly_rdiff" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "hourly";
        Persistent = true;
        unit = "hourly_rdiff.service";
      };
    };
    "daily_rdiff" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        unit = "daily_rdiff.service";
      };
    };
    "weekly_rdiff" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "weekly";
        Persistent = true;
        unit = "weekly_rdiff.service";
      };
    };
  };
}
