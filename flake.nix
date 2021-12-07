{
  description = "NixOS module for Linux on T2 Macs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
  };

  outputs = { self, nixpkgs }: rec {
    overlay = import ./overlay.nix;
    nixosModule = import ./modules/wifi-fw-selection.nix;

    nixosModules.wifi-firmware-selection = nixosModule;
  };
}