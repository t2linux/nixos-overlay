{ lib
, stdenv
, fetchurl
, macModel ? "MacBookPro15,1"
}:
let
  macOSRelease = "big-sur";
  firmwareTimestamp = "1620854225";
  normalizedModelName = lib.replaceStrings [ "," ] [ "_" ] macModel;
in
stdenv.mkDerivation rec {
  pname = "apple-wifi-firmware";
  version = "${macOSRelease}-${firmwareTimestamp}-${normalizedModelName}";

  src = fetchurl {
    url = "https://d0.ee/apple/${macOSRelease}-wifi-fw-${firmwareTimestamp}.tar.xz";
    sha256 = "sha256-YMeC8q+eccGkOUYR5hnNolKStpmcr6E4RVLdaHOiN2w=";
  };

  phases = [ "unpackPhase" "installPhase" ];

  passthru.firmwareMappings = rec {
    # Big Sur, 2021-05-13
    MacBookPro15_1 = {
      name = "MacBookPro15,1";
      base = "brcmfmac4364-pcie";

      firmware = "C-4364__s-B2/kauai.trx";
      regulatory = "C-4364__s-B2/kauai-X3.clmb";
      nvram = "C-4364__s-B2/P-kauai-X3_M-HRPN_V-u__m-7.5.txt";
    };

    # Big Sur, 2021-05-13
    MacBookPro15_2 = {
      name = "MacBookPro15,2";
      base = "brcmfmac4364-pcie";

      firmware = "C-4364__s-B2/maui.trx";
      regulatory = "C-4364__s-B2/maui-X0.clmb";
      nvram = "C-4364__s-B2/P-maui-X0_M-HRPN_V-u__m-7.5.txt";
    };

    # Big Sur, 2021-05-13
    MacBookPro15_3 = {
      name = "MacBookPro15,3";
      base = "brcmfmac4364-pcie";

      firmware = "C-4364__s-B2/maui.trx";
      regulatory = "C-4364__s-B2/maui-X3.clmb";
      nvram = "C-4364__s-B2/P-maui-X3_M-HRPN_V-m__m-7.7.txt";
    };

    MacBookPro15_4 = null; # unsupported - 2021-05-13

    # Big Sur, 2021-05-13
    MacBookPro16_1 = {
      name = "MacBookPro16,1";
      base = "brcmfmac4364-pcie";

      firmware = "C-4364__s-B3/bali.trx";
      regulatory = "C-4364__s-B3/bali-X3.clmb";
      nvram = "C-4364__s-B3/P-bali-X3_M-HRPN_V-u__m-7.7.txt";
    };

    # Big Sur, 2021-05-13
    MacBookPro16_2 = {
      name = "MacBookPro16,2";
      base = "brcmfmac4364-pcie";

      firmware = "C-4364__s-B3/trinidad.trx";
      regulatory = "C-4364__s-B3/trinidad-X0.clmb";
      nvram = "C-4364__s-B3/P-trinidad-X0_M-HRPN_V-u__m-7.7.txt";
    };

    # ?
    MacBookAir8_1 = {
      name = "MacBookAir8,1";
      base = "brcmfmac4355-pcie";

      firmware = "C-4355__s-C1/hawaii.trx";
      regulatory = "C-4355__s-C1/hawaii-X0.clmb";
      nvram = "C-4355__s-C1/P-hawaii-X0_M-YSBC_V-m__m-2.5.txt";
    };

    # Big Sur, 2021-05-17
    MacBookAir9_1 = {
      name = "MacBookAir9,1";
      base = "brcmfmac4377-pcie";

      firmware = "C-4377__s-B3/fiji.trx";
      regulatory = "C-4377__s-B3/fiji-X3.clmb";
      nvram = "C-4377__s-B3/P-fiji-X3_M-SPPR_V-u__m-3.1.txt";
    };
  };

  installPhase =
    let
      attrName = normalizedModelName;
      selectedFw = passthru.firmwareMappings.${attrName};
      modelName = "Apple Inc.-${selectedFw.name}";
    in
    ''
      runHook preInstall

      mkdir -p $out/lib/firmware/brcm

      cp -L ${selectedFw.firmware} $out/lib/firmware/brcm/${selectedFw.base}.bin
      cp -L ${selectedFw.regulatory} $out/lib/firmware/brcm/${selectedFw.base}.clm_blob
      cp -L ${selectedFw.nvram} $out/lib/firmware/brcm/${selectedFw.base}.'${modelName}'.txt

      runHook postInstall
    '';

  meta.license = lib.licenses.unfree;
}
