# Ref: https://nixos.wiki/wiki/Laptop
{

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
  services = {
    thermald.enable = true;
    # https://discourse.nixos.org/t/cant-enable-tlp-when-upgrading-to-21-05/13435/2
    power-profiles-daemon.enable = false;
  };
}
