{pkgs, ...}: let
  # Shell aliases
  myAliases = {
    ll = "ls -l";
    cat = "bat";
    neofetch = "fastfetch";
    ".." = "cd ..";
  };
in {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = myAliases;
  };

  home.packages = with pkgs; [
    fastfetch
    bat
  ];
}
