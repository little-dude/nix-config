{ pkgs, lib, ... }: {
  # Generated with dconf2nix
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      sources = [ (lib.hm.gvariant.mkTuple [ "xkb" "us" ]) ];
      # Swap caps lock and esc. This was first set with gnome-tweaks
      # then dconf2nix for the conversion
      xkb-options =
        [ "terminate:ctrl_alt_bksp" "caps:swapescape" "eurosign:e" ];
    };
    # alt+tab only switches through the windows in the current
    # workspace
    "org/gnome/shell/app-switcher" = { current-workspace-only = true; };
    "org/gnome/shell/window-switcher" = { current-workspace-only = true; };
    "org/gnome/desktop/sound" = {
      # Disable the fucking bell.
      #
      # dconf write /org/gnome/desktop/sound/event-sounds "false"
      event-sounds = false;
    };
  };
  home.packages = [ pkgs.gnome.gnome-tweaks ];
}
