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

  sops.defaultSopsFile = ./secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  # This file must be manually added by rsync or generating them:
  # $mkdir -p ~/.config/sops/age
  # $nix run nixpkgs#ssh-to-age - --private-key -i ~/.ssh/personalkey > ~/.config/sops/age/keys.txt
  # $chmod 400 ~/.config/sops/age/keys.txt
  sops.age.keyFile = ("/home" + ("/" + userSettings.username) + "/.config/sops/age/keys.txt");

  # Import secrets as shown below in the module that will use them
  # sops.secrets.hello = {};
  # sops.secrets.hello = {
    # owner = userSettings.username; # adding a user as an owner instead of root
  # };

  # Include sops to edit secrets
  environment.systemPackages = with pkgs; [
    sops
  ];
}
