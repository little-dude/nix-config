{ config, pkgs, ... }: {
  # Enabe pipewire for screensharing under wayland
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.xserver = {
    enable = true;
    displayManager = {
      gdm = { enable = true; };
      # sddm.enable = true;
    };
    layout = "us";
    desktopManager.gnome.enable = true;

    # desktopManager.xfce.enable = true;
    # Swap caps lock and esc. Note that in gnome, you have to use
    # gnome-tweaks and customize the keyboard
    # xkbOptions = "eurosign:e,caps:swapescape";
  };
  # Use our keyboard options in the console as well
  console.useXkbConfig = true;
}

# Note: in order to use xfce:
# - enable ssdm instead of gdm
# - add the nm-applet
# - add the xfce4-pulseaudia-plugin
# - enable blueman for bluetooth
