{ lib
, stdenv
, macModel ? "MacBookPro15,1"
}:
let
  normalizedModelName = lib.replaceStrings [ "," ] [ "_" ] macModel;
in
stdenv.mkDerivation rec {
  pname = "apple-wifi-firmware";
  version = "big-sur-1620854225-${normalizedModelName}";

  src = builtins.fetchTarball {
    url = "https://d0.ee/apple/big-sur-wifi-fw-1620854225.tar.zstd";
    sha256 = "023c19v6m5yf9zad81rkz5l4p21rc2p3jqgyyayykhqsxgh3y70i";
  };

  phases = [ "installPhase" ];

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
  };

  installPhase =
    let
      attrName = normalizedModelName;
      selectedFw = passthru.firmwareMappings.${attrName};
      modelName = "Apple Inc.-${selectedFw.name}";
    in
    ''
      mkdir -p $out/lib/firmware/brcm

      cp -L $src/${selectedFw.firmware} $out/lib/firmware/brcm/${selectedFw.base}.bin
      cp -L $src/${selectedFw.regulatory} $out/lib/firmware/brcm/${selectedFw.base}.clm_blob
      cp -L $src/${selectedFw.nvram} $out/lib/firmware/brcm/${selectedFw.base}.'${modelName}'.txt
    '';

  meta.license = lib.licenses.unfree;
}
