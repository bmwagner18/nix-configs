{ pkgs, userSettings, ... }:
{
  environment.systemPackages = with pkgs; [
    docker
  ];

  users.users.${userSettings.username}.extraGroups = [ "docker" ];

  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
    # rootless = {
      # enable = true;
      # setSocketVariable = true;
    # };
  };
}
