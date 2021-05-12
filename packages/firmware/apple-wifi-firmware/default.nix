{ lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "apple-wifi-firmware";
  version = "mojave";

  src = builtins.fetchTarball {
    url = "https://d0.ee/nixos/mojave-firmware.tar.zstd";
    sha256 = "128mfjjpw9a5s0ybcrq0dn7s55pgzn997j31szs4v68k7wp80227";
  };

  sourceRoot = "fw";

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/lib/firmware
    cp $src/* $out/lib/firmware/
  '';

  meta.license = lib.licenses.unfree;
}
