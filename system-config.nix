{ pkgs, config, ... }:
{
  # Improves system stability - https://canary.discord.com/channels/595304521857630254/595304521857630259/809475825589026826
  boot.kernelParams = [ "intel_iommu=on" ];

  # Use custom kernel
  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux-mbp;
  boot.extraModulePackages = with pkgs; [ apple-bce apple-ib-drv ];

  # Use GRUB
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };

  # Binary cache for t2linux derivations.
  nix = {
    binaryCaches = [
      "https://t2linux.cachix.org"
    ];
    binaryCachePublicKeys = [
      "t2linux.cachix.org-1:P733c5Gt1qTcxsm+Bae0renWnT8OLs0u9+yfaK2Bejw="
    ];
  };

  # suspend/resume is quite broken - 2021-05-12
  services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchDocked = "ignore";
  services.logind.lidSwitchExternalPower = "ignore";
}
