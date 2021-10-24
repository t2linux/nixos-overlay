{ stdenv, lib, fetchFromGitHub, kernel, kmod }:

stdenv.mkDerivation rec {
  name = "apple-ib-drv-${version}-${kernel.version}";
  gitCommit = "d8411ad1d87db8491e53887e36c3d37f445203eb";
  version = "${gitCommit}";

  src = fetchFromGitHub {
    owner = "t2linux";
    repo = "apple-ib-drv";
    rev = "${gitCommit}";
    sha256 = "0s8bh3hw6kbl0s766pl7bg5ffsxra7iwjqlykhqrgwiwiripvz4q";
  };

  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];
}
