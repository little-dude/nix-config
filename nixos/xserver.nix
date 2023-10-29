{ config, pkgs, ... }: {
  services.xserver = {
    enable = true;
    # Load nvidia driver for Xorg and Wayland (Xorg in our case)
    videoDrivers = [ "nvidia" ];
    displayManager = {
      gdm = {
        enable = true;
        # Screen sharing doesn't work for Teams in Wayland
        wayland = false;
      };
    };
    layout = "us";
    # Swap caps lock and esc. Note that in gnome, you have to use
    # gnome-tweaks and customize the keyboard
    xkbOptions = "eurosign:e,caps:swapescape";
    desktopManager.gnome.enable = true;
  };
  # Use our keyboard options in the console as well
  console.useXkbConfig = true;
}
