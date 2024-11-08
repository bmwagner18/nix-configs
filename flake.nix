{
  description = "Ben's shiny new flake";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager-unstable.url = "github:nix-community/home-manager/master";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager-stable.url = "github:nix-community/home-manager/release-24.05";
    home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";

    nixvim.url = "github:nix-community/nixvim/nixos-24.05";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs-stable";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };
  };

  outputs = inputs @ {self, ...}: let
    # ---- SYSTEM SETTINGS ---- #
    systemSettings = {
      system = "x86_64-linux"; # system arch
      hostname = "ben-laptop"; # hostname
      profile = "laptop"; # corresponds to profile in profiles directory
      release = "unstable"; # stable or unstable
      timezone = "America/New_York";
      locale = "en_US.UTF-8";
      bootMode = "uefi"; # uefi or bios
      bootMountPath = "/boot"; # mount point for EFI boots
      grubDevice = ""; # grub device for bios boot mode
    };

    # ---- USER SETTINGS ---- #
    userSettings = rec {
      username = "ben"; # username for home-manager
      name = "Ben"; # name or identifier
      email = "64104085+bmwagner18@users.noreply.github.com";
      nixconfigsDir = "~/nix-configs"; # where this flake is located
      wm = "plasma"; # Need file in ./user/wm and ./system/wm
      wmType = if ((wm == "hyprland") || (wm == "plasma")) then "wayland" else "x11";
      terminal = "alacritty";
    };

    # Configure pkgs
    pkgs-stable = import inputs.nixpkgs-stable {
      system = systemSettings.system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _:true;
      };
    };

    pkgs-unstable = import inputs.nixpkgs-unstable {
      system = systemSettings.system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _:true;
      };
    };

    pkgs =
      if (systemSettings.release == "stable")
      then pkgs-stable
      else pkgs-unstable;

    # Configure lib based on preferred release
    lib =
      if (systemSettings.release == "stable")
      then inputs.nixpkgs-stable.lib
      else inputs.nixpkgs-unstable.lib;

    # Configure home-manager based on preferred release
    home-manager =
      if (systemSettings.release == "stable")
      then inputs.home-manager-stable
      else inputs.home-manager-unstable;

    # Systems that can run tests:
    # supportedSystems = ["aarch64-linux" "i686-linux" "x86_64-linux"];
    # Function to generate a set based on supported systems
    # forAllSystems = inputs.nixpkgs-unstable.lib.genAttrs supportedSystems;
    # Attribute set of nixpkgs for each system
    # nixpkgsFor =
    # forAllSystems (system: import inputs.nixpkgs-unstable {inherit system;});

  in {
    nixosConfigurations = {
      system = lib.nixosSystem {
        system = systemSettings.system;
        # Load configuration.nix based on profile
        modules = [
          (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
	        ./system/bin/phoenix.nix
        ];
        specialArgs = {
          # allow stable packages to be used on unstable systems
          inherit pkgs-stable;
          inherit systemSettings;
          inherit userSettings;
          inherit inputs;
        };
      };
    };

    homeConfigurations = {
      user = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        # Load home.nix based on profile
        modules = [
          (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix")
        ];
        extraSpecialArgs = {
          # allow stable packages to be used on unstable systems
          inherit pkgs-stable;
          inherit systemSettings;
          inherit userSettings;
          inherit inputs;
        };
      };
    };



  };
}
