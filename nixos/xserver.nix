{
  services.displayManager = {
    gdm.enable = true;
    # sddm.enable = true;
  };
  services.desktopManager.gnome.enable = true;
  # Use our keyboard options in the console as well
  console.useXkbConfig = true;
  # xkb.layout = "us";
}
# Note: in order to use xfce:
# - enable ssdm instead of gdm
# - add the nm-applet
# - add the xfce4-pulseaudia-plugin
# - enable blueman for bluetooth

