{ config, lib, ... }:
with lib;
{
  options.hardware.appleWifiFirmware = {
    model = mkOption {
      description = "Configure your Apple device model to get correct WiFi firmware in place. This is temporary until WiFi driver becomes more intelligent";
      default = "MacBookPro15,1";
      type = types.enum [ "MacBookAir8,1" "MacBookAir9,1" "MacBookPro15,1" "MacBookPro15,2" "MacBookPro15,3" "MacBookPro16,1" "MacBookPro16,2" ];
    };
  };
}
