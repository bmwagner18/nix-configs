{ pkgs, ... }:
let
  myPythonEnv = pkgs.python3.withPackages (ps: with ps; [
    pyyaml
  ]);
in
{
  systemd.services = {
    "hourly_rdiff" = {
      script = ''
        ${myPythonEnv}/bin/python3 /home/ben/nix-configs/system/services/rdiff/backup.py -f HOURLY -p "/home/ben/rdiff/backups.yaml"
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "ben";
      };
    };
    "daily_rdiff" = {
      script = ''
        ${myPythonEnv}/bin/python3 /home/ben/nix-configs/system/services/rdiff/backup.py -f DAILY -p "/home/ben/rdiff/backups.yaml"
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "ben";
      };
    };
    "weekly_rdiff" = {
      script = ''
        ${myPythonEnv}/bin/python3 /home/ben/nix-configs/system/services/rdiff/backup.py -f WEEKLY -p "/home/ben/rdiff/backups.yaml"
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "ben";
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
