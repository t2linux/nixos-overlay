#!/bin/sh
set -e

nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
