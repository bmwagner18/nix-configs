{
  pkgs,
  userSettings,
  sops-nix-pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = ("/home" + ("/" + userSettings.username) + "/.config/sops/age/keys.txt");

  sops.secrets.hello = {
    # owner = userSettings.username; # adding a user as an owner
  };
  sops.secrets.nextcloud_env = {};
  sops.secrets.nextcloud_adminpassword = {};

  # Include sops to edit secrets
  environment.systemPackages = with pkgs; [
    sops
  ];
}
