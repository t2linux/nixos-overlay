#!/usr/bin/env bash
set -euo pipefail

: "${NIXPKGS}"

packages=(
	kernel/linux-mbp
	firmware/apple-wifi-firmware
)

modules=(
	apple-bce
	apple-ib-drv
)

built_drvs=()

nnix () {
	nix --extra-experimental-features 'nix-command flakes' "${@}"
}

for p in ${packages[@]}; do
	echo ">>> Building '${p}'"

	drv="$(nix-build --no-out-link -I nixpkgs="${NIXPKGS}" -E 'let pkgs = import <nixpkgs> {}; in pkgs.callPackage ./packages/'"${p}"' {}')"
	built_drvs+=($(nnix show-derivation "${drv}" | jq -r '.[keys[0]].outputs | .[].path'))

	echo ">>> Built '${p}' (-> '${drv}')"
	du -sh "${drv}"
done

for p in ${modules[@]}; do
	echo ">>> Building '${p}'"

	drv="$(nix-build --no-out-link -I nixpkgs="${NIXPKGS}" -E 'let pkgs = import <nixpkgs> {}; mbp = pkgs.callPackage ./packages/kernel/linux-mbp {}; in pkgs.callPackage ./packages/kernel-modules/'"${p}"' { kernel = mbp; }')"
	built_drvs+=($(nnix show-derivation "${drv}" | jq -r '.[keys[0]].outputs | .[].path'))

	echo ">>> Built '${p}' (-> '${drv}')"
	du -sh "${drv}"
done

if [ -n "${CACHIX_AUTH_TOKEN:-}" ]; then
	for d in ${built_drvs[@]}; do
		cachix push t2linux "${d}"
	done
fi
