{ pkgs, stdenv, lib, buildLinux, ... } @ args:

with lib;
let
  kernelVersion = "5.11.21";
in
buildLinux (args // rec {
  version = "${kernelVersion}-mbp";
  modDirVersion = kernelVersion;
  extraMeta.branch = versions.majorMinor version;

  src = pkgs.fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${kernelVersion}.tar.xz";
    sha256 = "0zw7mpq6lfbw2ycv4lvkya93h1h18gvc8c66m82bca5y02xsasrn";
  };

  # Set up kernel patches
  kernelPatches =
    let
      # Import patches what NixOS offers
      nixPatches = pkgs.callPackage <nixpkgs/pkgs/os-specific/linux/kernel/patches.nix> { };

      # https://github.com/aunali1/linux-mbp-arch/blob/master/PKGBUILD
      mbpPatches = [
        # Arch Linux patches
        ./0001-ZEN-Add-sysctl-and-CONFIG-to-disallow-unprivileged-C.patch
        ./0002-HID-quirks-Add-Apple-Magic-Trackpad-2-to-hid_have_sp.patch

        # Hack for AMD DC eDP link rate bug
        ./2001-drm-amd-display-Force-link_rate-as-LINK_RATE_RBR2-fo.patch

        # Apple SMC ACPI support
        ./3001-applesmc-convert-static-structures-to-drvdata.patch
        ./3002-applesmc-make-io-port-base-addr-dynamic.patch
        ./3003-applesmc-switch-to-acpi_device-from-platform.patch
        ./3004-applesmc-key-interface-wrappers.patch
        ./3005-applesmc-basic-mmio-interface-implementation.patch
        ./3006-applesmc-fan-support-on-T2-Macs.patch

        # T2 USB Keyboard/Touchpad support
        ./4001-HID-apple-Add-support-for-keyboard-backlight-on-supp.patch
        ./4002-HID-apple-Add-support-for-MacbookAir8-1-keyboard-tra.patch
        ./4003-HID-apple-Add-support-for-MacBookPro15-2-keyboard-tr.patch
        ./4004-HID-apple-Add-support-for-MacBookPro15-1-keyboard-tr.patch
        ./4005-HID-apple-Add-support-for-MacBookPro15-4-keyboard-tr.patch
        ./4006-HID-apple-Add-support-for-MacBookPro16-2-keyboard-tr.patch
        ./4007-HID-apple-Add-support-for-MacBookPro16-3-keyboard-tr.patch
        ./4008-HID-apple-Add-support-for-MacBookAir9-1-keyboard-tra.patch
        ./4009-HID-apple-Add-support-for-MacBookPro16-1-keyboard-tr.patch

        # Broadcom Wifi rambase debugging additions
        ./5001-brcmfmac-move-brcmf_mp_device-into-its-own-header.patch
        ./5002-brcmfmac-Add-ability-to-manually-specify-FW-rambase-.patch

        # MBP Peripheral support
        ./6001-media-uvcvideo-Add-support-for-Apple-T2-attached-iSi.patch # UVC Camera support

        # Hack for i915 overscan issues
        ./7001-drm-i915-fbdev-Discard-BIOS-framebuffers-exceeding-h.patch

        # Broadcom WIFI/BT device support
        ./8001-brcmfmac-Add-initial-support-for-the-BRCM4355.patch
        ./8002-brcmfmac-Add-initial-support-for-the-BRCM4377.patch

        # MacBookPro16,1/2 WIFI support
        ./wifi-bigsur.patch
      ];
    in
    (map (x: { name = baseNameOf x; patch = x; }) mbpPatches) ++ [
      nixPatches.bridge_stp_helper
      nixPatches.request_key_helper
      #nixPatches.export_kernel_fpu_functions."5.3" # TODO: doesn't apply - however this patch is not very important right now.
    ];
} // (args.argsOverride or { }))
