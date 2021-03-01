#!/bin/sh
set -euo pipefail

NIXPKGS=channel:nixos-20.09

drv="$(nix-build --no-out-link -I nixpkgs="${NIXPKGS}" -E 'let pkgs = import <nixpkgs> {}; in pkgs.callPackage ./packages/kernel/linux-mbp {}')"

echo ">>> Built '${drv}'"
du -sh "${drv}"

if [ -n "${drv}" ] && [ -n "${CACHIX_AUTH_TOKEN}" ] && [ -n "${CACHIX_SIGNING_KEY}" ]; then
        cachix push t2linux "${drv}"
fi
