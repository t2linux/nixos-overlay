{
  nixpkgs.overlays = [
    (import ./overlay.nix)
  ];
}
