{ config, pkgs, userSettings, ... }:

{
  home.packages = [ pkgs.neovim ];
#   program.neovim.enable = true;
}