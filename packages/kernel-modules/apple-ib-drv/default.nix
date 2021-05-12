{ stdenv, lib, fetchFromGitHub, kernel, kmod }:

stdenv.mkDerivation rec {
  name = "apple-ib-drv-${version}-${kernel.version}";
  gitCommit = "fc9aefa5a564e6f2f2bb0326bffb0cef0446dc05";
  version = "${gitCommit}";

  src = fetchFromGitHub {
    owner = "t2linux";
    repo = "apple-ib-drv";
    rev = "${gitCommit}";
    sha256 = "0bs9i0wqgvi1whss06xpfcicipwg2j2mcskg29swj2vsdbvdifz4";
  };

  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];
}
