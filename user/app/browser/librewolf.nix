{
  config,
  pkgs,
  userSettings,
}: {
  home.packages = [pkgs.librewolf];
  programs.librewolf = {
    enable = true;
    # defaultFont = "JetBrainsMono Nerd Font"
    settings = {
      identity.fxaccounts.enabled = true;
      privacy.resistFingerprinting = true;
      privacy.clearOnShutdown.history = false;
      privacy.clearOnShutdown.cookies = true;
      # browser.startup.homepage = 
    };
  };
}
