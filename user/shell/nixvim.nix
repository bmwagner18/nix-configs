{ config, pkgs, nixvim, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    colorschemes.gruvbox = true;
    plugins = {
      nvim-tree = {
        enable = true;
        openOnSetupFile = true;
        autoReloadOnWrite = true;
      };
      lspsaga = {
        enable = true;
      };
    };
  };
}
