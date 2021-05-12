#!/usr/bin/env bash
set -euo pipefail

NIXPKGS=channel:nixos-20.09

packages=(
	firmware/apple-wifi-firmware
	kernel/linux-mbp
)

modules=(
	apple-bce
	apple-ib-drv
)

built_packages=()
built_modules=()

for p in ${packages[@]}; do
	echo ">>> Building '${p}'"

	drv="$(nix-build --no-out-link -I nixpkgs="${NIXPKGS}" -E 'let pkgs = import <nixpkgs> {}; in pkgs.callPackage ./packages/'"${p}"' {}')"
	built_packages+=(${drv})

	echo ">>> Built '${p}' (-> '${drv}')"
	du -sh "${drv}"
done

for p in ${modules[@]}; do
	echo ">>> Building '${p}'"

	drv="$(nix-build --no-out-link -I nixpkgs="${NIXPKGS}" -E 'let pkgs = import <nixpkgs> {}; mbp = pkgs.callPackage ./packages/kernel/linux-mbp {}; in pkgs.callPackage ./packages/kernel-modules/'"${p}"' { kernel = mbp; }')"
	built_packages+=(${drv})

	echo ">>> Built '${p}' (-> '${drv}')"
	du -sh "${drv}"
done

if [ -n "${CACHIX_AUTH_TOKEN}" ] && [ -n "${CACHIX_SIGNING_KEY}" ]; then
	for d in ${built_packages[@]}; do
		cachix push t2linux "${d}"
	done

	for d in ${built_modules[@]}; do
		cachix push t2linux "${d}"
	done
fi
