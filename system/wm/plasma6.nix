{ ... }:

{

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  # KDE Plasma 6 is now available on unstable
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";

  # Display Manager
  displayManager = {
      sddm = {
        enable = true;
        autoNumlock = true;
      };
      # defaultSession = "plasmawayland";
    };
  };
}