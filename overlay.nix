self: super:
let
  callPackage = super.callPackage;
in
{
  linux-mbp = callPackage ./packages/kernel/linux-mbp { };
  apple-bce = callPackage ./packages/kernel-modules/apple-bce { kernel = self.linux-mbp; };
  apple-ib-drv = callPackage ./packages/kernel-modules/apple-ib-drv { kernel = self.linux-mbp; };
  apple-wifi-firmware = callPackage ./packages/firmware/apple-wifi-firmware { };
}
