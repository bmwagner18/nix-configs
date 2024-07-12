{
  description = "Ben's flake";

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      # ---- SYSTEM SETTINGS ---- #
      systemSettings = {
        system = "x86_64-linux"; # system arch
        hostname = "ben-pc"; # hostname (must have a corresponding folder in ./hosts)
        timezone = "America/New_York"; # select timezone
        locale = "en_US.UTF-8"; # select locale
        bootMode = "bios"; # uefi or bios
        bootMountPath = "/"; # mount path for efi boot partition; only used for uefi boot mode
        grubDevice = "/dev/sda"; # device identifier for grub; only used for legacy (bios) boot mode
      };

      # ----- USER SETTINGS ----- #
      userSettings = rec {
        username = "ben"; # username
        name = "Ben"; # name/identifier
        email = "64104085+bmwagner18@users.noreply.github.com"; # email (used for certain configurations)
        nixconfigsDir = "/home/ben/nix-configs"; # absolute path of the local repo
      };

      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${systemSettings.system};
in {
      homeConfigurations = {
        user = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
             (./. + "/hosts" + ("/" + systemSettings.hostname) + "/home.nix")
          ];
          extraSpecialArgs = {
            # pass config variables from above
            inherit systemSettings;
            inherit userSettings;
          };
        };
      };

      nixosConfigurations = {
        system = lib.nixosSystem {
          system = systemSettings.system;
          modules = [
            (./. + "/hosts" + ("/" + systemSettings.hostname) + "/configuration.nix")
            ./system/bin/phoenix.nix
          ];
          specialArgs = {
            # pass config variables from above
            inherit systemSettings;
            inherit userSettings;
          };
        };
      };

      # This *should* automate the installation when this command is run:
      # nix-shell -p git --command "nix run --experimental-features 'nix-command flakes' github:bmwagner18/nix-configs"
# z      packages = forAllSystems (system:
#         let pkgs = nixpkgsFor.${system};
#         in {
#           default = self.packages.${system}.install;

#           install = pkgs.writeShellApplication {
#             name = "install";
#             runtimeInputs = with pkgs; [ git ]; # I could make this fancier by adding other deps
#             text = ''${./install.sh} "$@"'';
#           };
#         });

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nixvim.url = "github:nix-community/nixvim";
    # nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };
  };
}
