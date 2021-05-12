{ pkgs, fetchgit }:

pkgs.iwd.overrideAttrs (oldAttrs: rec {
  version = "1.12";
})
