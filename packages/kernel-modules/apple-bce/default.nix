{ stdenv, lib, fetchFromGitHub, kernel, kmod }:

stdenv.mkDerivation rec {
  name = "apple-bce-${version}-${kernel.version}";
  gitCommit = "e1cd77ef4736df9e452cb26f85ee81a5349f8f1e";
  version = "${gitCommit}";

  src = fetchFromGitHub {
    owner = "mikroskeem";
    repo = "mbp2018-bridge-drv";
    rev = "${gitCommit}";
    sha256 = "1sf9pzrvvgc9mr0fqjcg6rwxp4j4qv8rdpg7nj8l5nzaj6z0awdj";
  };

  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];
}
