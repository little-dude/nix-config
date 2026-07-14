{pkgs, ...}: {
  # Generated with dconf2nix
  dconf.settings = {
    # alt+tab only switches through the windows in the current
    # workspace
    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };
    "org/gnome/shell/window-switcher" = {
      current-workspace-only = true;
    };
    "org/gnome/desktop/sound" = {
      # Disable the fucking bell.
      #
      # dconf write /org/gnome/desktop/sound/event-sounds "false"
      event-sounds = false;
    };
  };
  home.packages = [pkgs.gnome-tweaks];
}
