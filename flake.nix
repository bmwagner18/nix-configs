{
  description = "Ben's flake";

  outputs = { self, nixpkgs, home-manager ... }:
    let
      # ---- SYSTEM SETTINGS ---- #
      systemSettings = {
        system = "x86_64-linux"; # system arch
        hostname = "ben-laptop"; # hostname (must have a corresponding folder in ./hosts)
        timezone = "America/Chicago"; # select timezone
        locale = "en_US.UTF-8"; # select locale
      };

      # ----- USER SETTINGS ----- #
      userSettings = rec {
        username = "ben"; # username
        name = "Ben"; # name/identifier
        email = "bmwagner@proton.me"; # email (used for certain configurations)
        nixconfigsDir = "~/.nix-configs"; # absolute path of the local repo
      };

      lib = nixpkgs.legacypackages.${system};

    in {
      homeConfigurations = {
        user = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
             (./. + "/hosts" + ("/" + systemSettings.hostname) + "/home.nix")
          ];
          extraSpecialArgs = {
            # pass config variables from above
            inherit pkgs-stable;
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
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
            inherit pkgs-stable;
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
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
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  };
};