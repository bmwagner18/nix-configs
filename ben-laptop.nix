# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    # ./hardware-configuration.nix
    # ./modules/ben-laptop-wg.nix # Wireguard confirmation for this system
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "ben-laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable wireguard tunnel to my apartment via wg-quick
  # networking.wg-quick.interfaces = {
  #   wg0 = {
  #     address = ["172.16.16.2/32"];
  #     dns = ["192.168.35.5"];
  #     privateKeyFile = "/home/ben/wireguard-keys/privatekey";
  #     peers = [
  #       {
  #         publicKey = "fZOk0DLcPQfphOuU5LPYU5fOvD0WGyoH9+NSdoG+fwY=";
  #         presharedKeyFile = "/home/ben/wireguard-keys/presharedkey";
  #         allowedIPs = ["172.16.16.0/24" "192.168.35.0/24"];
  #         endpoint = "quesadilla.cloud:51820";
  #         persistentKeepalive = 25;
  #       }
  #     ];
  #   };
  # };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ben = {
    isNormalUser = true;
    description = "Ben";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      firefox
      #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    vscode # I want to tell people I can use vim but I really a vscode noob
    wireguard-tools # To make keys and stuff
    alejandra # Autoformatting of .nix files
    git # Version control, you know what git does...
    libnotify # Desktop notifications used when rebuilding nix
    super-slicer-latest # 3D printer slicer forked from PrusaSlicer but better
    joplin-desktop # My current notes app of choice
    slack # Messaging app
    discord # Other messaging app
    distrobox # Run another distro in the shell easily
    # docker # My container manager of choise at the moment
  ];

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # required public key auth for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    # settings.PermitRootLogin = "yes";
  };

  # Enable SSH key authentication
  users.users."ben".openssh.authorizedKeys.keyFiles = [
    ./ssh/authorized_keys
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
