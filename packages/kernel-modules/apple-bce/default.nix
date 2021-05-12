{ stdenv, lib, fetchFromGitHub, kernel, kmod }:

stdenv.mkDerivation rec {
  name = "apple-bce-${version}-${kernel.version}";
  gitCommit = "839131c386aa53171fe01e540cca4248f86b1528";
  version = "${gitCommit}";

  src = fetchFromGitHub {
    owner = "mikroskeem";
    repo = "mbp2018-bridge-drv";
    rev = "${gitCommit}";
    sha256 = "0s3p4vss7dkd24r26kfcg7vfc3sw6p7vyahz83vj0bb532sck7jm";
  };

  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];
}
