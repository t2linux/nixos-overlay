self: super:
let
  callPackage = super.callPackage;
in
{
  linux-mbp = callPackage ./packages/kernel/linux-mbp { };
  apple-bce = callPackage ./packages/kernel-modules/apple-bce { kernel = self.linux-mbp; };
}
