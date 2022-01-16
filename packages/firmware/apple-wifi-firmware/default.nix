{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, python310
}:
let
  macOSRelease = "big-sur";
  firmwareTimestamp = "1620854225";
in
stdenv.mkDerivation rec {
  pname = "apple-wifi-firmware";
  version = "${macOSRelease}-${firmwareTimestamp}";

  src = fetchurl {
    url = "https://d0.ee/apple/${macOSRelease}-wifi-fw-${firmwareTimestamp}.tar.xz";
    sha256 = "sha256-YMeC8q+eccGkOUYR5hnNolKStpmcr6E4RVLdaHOiN2w=";
  };

  asahi_installer = fetchFromGitHub {
    owner = "asahilinux";
    repo = "asahi-installer";
    rev = "b5d4e49a57fb1538fa5db0934cac113136a08fbb";
    sha256 = "sha256-I4rWT4s0KKp55e21oQhXaCEHf0KXb7I7rW3ieuTyLoE=";
  };

  nativeBuildInputs = [ python310 ];
  phases = [ "unpackPhase" "installPhase" ];

  installPhase =
    ''
      runHook preInstall

      mkdir -p $out/lib/firmware
	  
      dir=$PWD

      cd $asahi_installer/src
      python -m firmware.wifi $dir $out/lib/firmware/firmware.tar

      cd $out/lib/firmware
      tar xf firmware.tar
      rm firmware.tar

      runHook postInstall
    '';

  meta.license = lib.licenses.unfree;
}
