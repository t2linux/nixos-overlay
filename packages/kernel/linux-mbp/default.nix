{ stdenv, lib, buildLinux, fetchurl, kernelPatches, ... } @ args:

with lib;
let
  kernelVersion = "5.14.13";
in
buildLinux (args // rec {
  version = "${kernelVersion}-mbp";
  modDirVersion = kernelVersion;
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${kernelVersion}.tar.xz";
    sha256 = "0kcn9g5jyd043f75wk3k34j430callzhw5jh1if9zacqq2s7haw3";
  };

  # Set up kernel patches
  # https://github.com/jamlam/mbp-16.1-linux-wifi/blob/main/PKGBUILD
  kernelPatches = (map (x: { name = baseNameOf x; patch = x; }) [
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

    # MBP Peripheral support
    ./6001-media-uvcvideo-Add-support-for-Apple-T2-attached-iSi.patch # UVC Camera support

    # Hack for i915 overscan issues
    ./7001-drm-i915-fbdev-Discard-BIOS-framebuffers-exceeding-h.patch

    # Broadcom WIFI/BT device support
    ./8001-corellium-wifi-bigsur.patch
    ./8002-Add-support-for-BCM4377.patch
    ./8003-Add-support-for-BCM4355.patch

    ./9001-bluetooth-add-disable-read-tx-power-quirk.patch
    ./9002-add-bluetooth-support-for-16-2.patch
  ])
  ++ [
    kernelPatches.bridge_stp_helper
    kernelPatches.request_key_helper
  ];
} // (args.argsOverride or { }))
