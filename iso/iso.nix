{ config
, pkgs
, lib
, ...
}:

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    ../default.nix
    ../system-config.nix
  ];

  networking = {
    # Seems like wpa_supplicant does not work with Broadcom wifi chip on Macbook Pro 15,1 as of 2020-06-13, but
    # iwd seems to work (almost) flawlessly.
    wireless.enable = false;
    wireless.iwd.enable = true;
  };

  hardware.firmware = with pkgs;
    [ firmwareLinuxNonfree ];
}
