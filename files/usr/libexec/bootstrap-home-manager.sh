#!/bin/bash

mkdir -p ${HOME}/.config/home-manager

cat > ${HOME}/.config/home-manager/flake.nix <<EOF
{
  description = "Bootstraping NIX Home Manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.\${system};
    in {
      homeConfigurations.me = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ 
          ./home.nix
        ];
      };
    };
}
EOF

cat > ${HOME}/.config/home-manager/home.nix <<EOF
{ config, pkgs, ... }:

{

  # --------------------------------------------------------------------------
  # Enable the NixOS module for generic Linux systems
  # --------------------------------------------------------------------------
  targets.genericLinux.enable = true;
  targets.genericLinux.nixGL.packages = null;
  targets.genericLinux.gpu.enable = true;

  # --------------------------------------------------------------------------
  # Home identity
  # --------------------------------------------------------------------------
  home.username = "${USER}";
  home.homeDirectory = "${HOME}";

  # --------------------------------------------------------------------------
  # make packages managed by NIX available to Sway
  # --------------------------------------------------------------------------
  systemd.user.sessionVariables = {
    PATH = "$HOME/.nix-profile/bin:$HOME/.local/bin:/nix/var/nix/profiles/default/bin:/usr/local/sbin:/usr/local/bin:/usr/bin";
  };

  # --------------------------------------------------------------------------
  # State version — do not change after first activation
  # --------------------------------------------------------------------------
  home.stateVersion = "26.11";
}
EOF

if ! command -v home-manager >/dev/null; then
    nix profile install github:nix-community/home-manager
fi

home-manager switch --flake ${HOME}/.config/home-manager#me