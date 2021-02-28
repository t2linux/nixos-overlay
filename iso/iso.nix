{ config
, pkgs
, ...
}:

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    ../default.nix
  ];

  networking = {
    enableB43Firmware = true;

    # Seems like wpa_supplicant does not work with Broadcom wifi chip on Macbook Pro 15,1 as of 2020-06-13, but
    # iwd seems to work (almost) flawlessly.
    wireless.enable = false;
    wireless.iwd.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    b43FirmwareCutter
    b43Firmware_5_1_138
    b43Firmware_6_30_163_46
    firmwareLinuxNonfree
  ];

  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux-mbp;
}
