{ pkgs, ... }: {
  users.users.little-dude.extraGroups = [ "scanner" "lp" ];
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      gutenprintBin
      hplip
      hplipWithPlugin
      samsung-unified-linux-driver
      splix
      brlaser
      brgenml1lpr
      brgenml1cupswrapper
    ];
  };
  # Scanner
  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [ epkowa utsushi hplipWithPlugin ];
  };
  services.udev.packages = [ pkgs.utsushi ];
  # Discover printers/scanners on the network
  services.avahi.enable = true;
  # Important to resolve .local domains of printers, otherwise you get an error
  # like  "Impossible to connect to XXX.local: Name or service not known"
  services.avahi.nssmdns = true;
}
