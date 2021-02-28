{ pkgs ? import <nixpkgs> {}
, lib ? pkgs.lib
, stdenv ? pkgs.stdenv
, ...
}:

stdenv.mkDerivation rec {
  pname = "apple-wifi-firmware";
  version = "not-done-yet";

  srcs = [];

  phases = [ "installPhase" ];

  installPhase = ''

  '';

  meta.broken = true;
}
