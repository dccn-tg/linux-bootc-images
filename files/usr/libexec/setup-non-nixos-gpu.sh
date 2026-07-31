#!/usr/bin/env bash

set -euo pipefail

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
  # State version — do not change after first activation
  # --------------------------------------------------------------------------
  home.stateVersion = "26.11";
}
EOF

nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
nix-channel --update

# The full `non-nixos-gpu-setup` command printed on the screen if it requires to be executed with `sudo`.
GPU_SETUP=$( 
    home-manager switch 2>/dev/null \
    | grep -oE 'sudo[[:space:]]+/.*/non-nixos-gpu-setup$' 2>/dev/null \
    | sed -E 's/sudo[[:space:]]+//'
)

if [[ -n "$GPU_SETUP" ]]; then
    echo "Running: $GPU_SETUP"
    bash -c "$GPU_SETUP"
fi