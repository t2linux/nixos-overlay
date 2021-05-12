self: super:
let
  callPackage = super.callPackage;
in
{
  linux-mbp = callPackage ./packages/kernel/linux-mbp { };
}
