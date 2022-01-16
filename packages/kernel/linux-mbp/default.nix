{ pkgs, stdenv, lib, buildLinux, ... } @ args:

with lib;
let
  kernelVersion = "5.16.1";
in
buildLinux (args // rec {
  version = "${kernelVersion}-mbp";
  modDirVersion = kernelVersion;
  extraMeta.branch = versions.majorMinor version;

  src = pkgs.fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${kernelVersion}.tar.xz";
    sha256 = "sha256-x782IxxuoeZyg4AqAFQw0U/j+KNJjAckujQ5r69yNUU=";
  };

  # Set up kernel patches
  kernelPatches =
    let
      # Import patches what NixOS offers
      nixPatches = pkgs.callPackage <nixpkgs/pkgs/os-specific/linux/kernel/patches.nix> { };

      # https://github.com/Redecorating/mbp-16.1-linux-wifi/blob/main/PKGBUILD
      mbpPatches = [
        # Arch Linux patches
        ./0001-ZEN-Add-sysctl-and-CONFIG-to-disallow-unprivileged-C.patch
        ./0002-HID-quirks-Add-Apple-Magic-Trackpad-2-to-hid_have_sp.patch

        # Fix NVRAM writes
        ./0101-efi-runtime-avoid-EFIv2-runtime-services-on-Apple-x8.patch

        # Hack for AMD DC eDP link rate bug
        ./2001-drm-amd-display-Force-link_rate-as-LINK_RATE_RBR2-fo.patch

        # Apple SMC ACPI support
        ./3001-applesmc-convert-static-structures-to-drvdata.patch
        ./3002-applesmc-make-io-port-base-addr-dynamic.patch
        ./3003-applesmc-switch-to-acpi_device-from-platform.patch
        ./3004-applesmc-key-interface-wrappers.patch
        ./3005-applesmc-basic-mmio-interface-implementation.patch
        ./3006-applesmc-fan-support-on-T2-Macs.patch
        ./3007-applesmc-Add-iMacPro-to-applesmc_whitelist.patch
        
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
        ./4010-HID-apple-Add-ability-to-use-numbers-as-function-key.patch

        # MBP Peripheral support
        ./6001-media-uvcvideo-Add-support-for-Apple-T2-attached-iSi.patch       # UVC Camera support

        # Hack for i915 overscan issues
        ./7001-drm-i915-fbdev-Discard-BIOS-framebuffers-exceeding-h.patch

        # Broadcom WIFI device support
        ./8001-brcmfmac-pcie-Declare-missing-firmware-files-in-pcie.patch
        ./8002-brcmfmac-firmware-Support-having-multiple-alt-paths.patch
        ./8003-brcmfmac-firmware-Handle-per-board-clm_blob-files.patch
        ./8004-brcmfmac-pcie-sdio-usb-Get-CLM-blob-via-standard-fir.patch
        ./8005-brcmfmac-firmware-Support-passing-in-multiple-board_.patch
        ./8006-brcmfmac-pcie-Read-Apple-OTP-information.patch
        ./8007-brcmfmac-of-Fetch-Apple-properties.patch
        ./8008-brcmfmac-pcie-Perform-firmware-selection-for-Apple-p.patch
        ./8009-brcmfmac-firmware-Allow-platform-to-override-macaddr.patch
        ./8010-brcmfmac-msgbuf-Increase-RX-ring-sizes-to-1024.patch
        ./8011-brcmfmac-pcie-Fix-crashes-due-to-early-IRQs.patch
        ./8012-brcmfmac-pcie-Support-PCIe-core-revisions-64.patch
        ./8013-brcmfmac-pcie-Add-IDs-properties-for-BCM4378.patch
        ./8014-ACPI-property-Support-strings-in-Apple-_DSM-props.patch
        ./8015-brcmfmac-acpi-Add-support-for-fetching-Apple-ACPI-pr.patch
        ./8016-brcmfmac-pcie-Provide-a-buffer-of-random-bytes-to-th.patch
        ./8017-brcmfmac-pcie-Add-IDs-properties-for-BCM4355.patch
        ./8018-brcmfmac-pcie-Add-IDs-properties-for-BCM4377.patch
        ./8019-brcmfmac-pcie-Perform-correct-BCM4364-firmware-selec.patch
        ./8020-brcmfmac-chip-Only-disable-D11-cores-handle-an-arbit.patch
        ./8021-brcmfmac-chip-Handle-1024-unit-sizes-for-TCM-blocks.patch
        ./8022-brcmfmac-cfg80211-Add-support-for-scan-params-v2.patch
        ./8023-brcmfmac-feature-Add-support-for-setting-feats-based.patch
        ./8024-brcmfmac-cfg80211-Add-support-for-PMKID_V3-operation.patch
        ./8025-brcmfmac-cfg80211-Pass-the-PMK-in-binary-instead-of-.patch
        ./8026-brcmfmac-pcie-Add-IDs-properties-for-BCM4387.patch
        ./8027-brcmfmac-pcie-Replace-brcmf_pcie_copy_mem_todev-with.patch
        ./8028-brcmfmac-pcie-Read-the-console-on-init-and-shutdown.patch
        ./8029-brcmfmac-pcie-Release-firmwares-in-the-brcmf_pcie_se.patch
        ./8031-brcmfmac-fwil-Constify-iovar-name-arguments.patch
        ./8032-brcmfmac-common-Add-support-for-downloading-TxCap-bl.patch
        ./8033-brcmfmac-pcie-Load-and-provide-TxCap-blobs.patch
        ./8034-brcmfmac-common-Add-support-for-external-calibration.patch
      ];
    in
    (map (x: { name = baseNameOf x; patch = x; }) mbpPatches) ++ [
      nixPatches.bridge_stp_helper
      nixPatches.request_key_helper
      #nixPatches.export_kernel_fpu_functions."5.3" # TODO: doesn't apply - however this patch is not very important right now.
    ];
} // (args.argsOverride or { }))
