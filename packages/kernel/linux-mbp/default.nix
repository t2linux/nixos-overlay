{ pkgs ? import <nixpkgs> {}
, stdenv ? pkgs.stdenv
, lib ? stdenv.lib
, buildLinux ? pkgs.buildLinux
, ...
} @ args:

with lib;
buildLinux (args // rec {
  kernelVersion = "5.6.18";
  version = "${xanmodVersion}-mbp";
  modDirVersion = version;
  extraMeta.branch = versions.majorMinor version;

  # TODO
  #src =

  # Set up kernel patches
  kernelPatches = let
    # Import patches what NixOS offers
    nixPatches = import <nixpkgs/pkgs/os-specific/linux/kernel/patches.nix> { fetchpatch = lib.fetchpatch; };
  in
  [ nixPatches.bridge_stp_helper
    nixPatches.request_key_helper
    nixPatches.export_kernel_fpu_functions."5.3"

    # TODO
  ];
} // (args.argsOverride or {}))

