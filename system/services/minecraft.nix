{ pkgs, lib, inputs, userSettings, ... }:

{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
    ../../secrets/sops.nix
  ];

  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    # dataDir = "/srv/minecraft" # servers are shared in their own dir below

    servers = {
      server-1 = {
        enable = true;
        autoStart = true;
        restart = "always";
        enableReload = true;
        openFirewall = true;
        # jvmOpts = "-Xms6144M -Xmx8192M";
        package = pkgs.fabricServers.fabric-1_21_1;

        serverProperties = {
          server-port = 25565;
          motd = "Ben's NixOS Minecraft server!";
          server-name = "Ben's NixOS Minecraft server!";
          # difficulty = "normal";
          max-players = 5;
        };

        whitelist = {/* */};

        # Mods:
        symlinks =
        let
          modpack = (pkgs.fetchPackwizModpack {
            url = "https://raw.githubusercontent.com/bmwagner18/modpacks/main/pack.toml";
            packHash = "sha256-7C8Zz11vuZwn/KiFmpziZGzuElZokhsG7UTscsAYkuo=";
          });
        in
        {
          # Use modpack (use the let, in above)
          "mods" = "${modpack}/mods";

          # Use local directory
          # "mods" = ./mods;

          # "mods" = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
            # Lithium = fetchurl { url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/5szYtenV/lithium-fabric-mc1.21.1-0.13.0.jar"; };
            # Krypton = fetchurl { url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/Acz3ttTp/krypton-0.2.8.jar"; };
            # FerriteCore = fetchurl { url = "https://cdn.modrinth.com/data/uXXizFIs/versions/wmIZ4wP4/ferritecore-7.0.0-fabric.jar"; };
            # C2ME = fetchurl { url = "https://cdn.modrinth.com/data/VSNURh3q/versions/5CmOS3yK/c2me-fabric-mc1.21.1-0.3.0%2Balpha.0.150.jar"; };
          # });
        };
      };
    };
  };
}
