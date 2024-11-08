{ inputs, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kitty
  ];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland = {
      enable = true;
    };
  };

  services.xserver.excludePackages = [ pkgs.xterm ];

  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.sddm;
    };
    # desktopManager.hyprland.enable = true;
  };
}
