#!/bin/sh
set -euo pipefail

NIXPKGS=channel:nixos-20.09

nix-build '<nixpkgs/nixos>' -I nixos-config=iso.nix -I nixpkgs="${NIXPKGS}" -A config.system.build.isoImage
