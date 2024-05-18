{ config, pkgs, userSettings, ... }:

{
  home.packages = [ pkgs.mullvad-vpn ];
#   program.mullvad-vpn.enable = true;
}