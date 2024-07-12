#!/bin/sh

# Modified from librephoenix/nixos-config

# Clone dotfiles
if [ $# -gt 0 ]
  then
    SCRIPT_DIR=$1
  else
    SCRIPT_DIR=~/nix-configs
fi
# nix-shell -p git --command "git clone https://github.com/bmwagner18/nix-configs $SCRIPT_DIR"

# Generate hardware config for new system
sudo nixos-generate-config --show-hardware-config > $SCRIPT_DIR/system/hardware-configuration.nix

# Open up editor to manually edit flake.nix before install
if [ -z "$EDITOR" ]; then
    EDITOR=nano;
fi
$EDITOR $SCRIPT_DIR/flake.nix;

# Rebuild system
sudo nixos-rebuild switch --flake $SCRIPT_DIR#system;

# Install and build home-manager configuration
nix run home-manager/master --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake $SCRIPT_DIR#user;
