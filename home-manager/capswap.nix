{
  pkgs,
  lib,
  ...
}: let
  swapOption = "caps:swapescape";

  toggle-caps-swap = pkgs.writeShellApplication {
    name = "toggle-caps-swap";
    runtimeInputs = [pkgs.glib pkgs.gnused];
    text = ''
      schema=org.gnome.desktop.input-sources
      opts=$(gsettings get $schema xkb-options)

      case "''${1:-toggle}" in
        on) want=on ;;
        off) want=off ;;
        toggle)
          if [[ $opts == *"'${swapOption}'"* ]]; then want=off; else want=on; fi
          ;;
        *)
          echo "usage: toggle-caps-swap [on|off]" >&2
          exit 1
          ;;
      esac

      if [[ $want == off ]]; then
        opts=$(sed -e "s/'${swapOption}', //" -e "s/, '${swapOption}'//" -e "s/'${swapOption}'//" <<<"$opts")
        msg="caps/esc swap disabled"
      elif [[ $opts != *"'${swapOption}'"* ]]; then
        opts="''${opts%]}, '${swapOption}']"
        msg="caps/esc swap enabled"
      else
        msg="caps/esc swap already enabled"
      fi

      gsettings set $schema xkb-options "$opts"

      # GNOME 50 on Wayland does not rebuild the keymap when only
      # xkb-options changes (a sources change does trigger a rebuild),
      # so nudge the sources list to force one.
      sources=$(gsettings get $schema sources)
      gsettings set $schema sources "''${sources%]}, ('xkb', 'fr')]"
      gsettings set $schema sources "$sources"

      echo "$msg"
    '';
  };
in {
  dconf.settings."org/gnome/desktop/input-sources" = {
    sources = [
      (lib.hm.gvariant.mkTuple [
        "xkb"
        "us"
      ])
    ];
    # Swap caps lock and esc by default. Flip it at runtime with
    # toggle-caps-swap; the swap comes back at the next boot or rebuild,
    # when home-manager rewrites dconf.
    xkb-options = [
      "terminate:ctrl_alt_bksp"
      swapOption
      "eurosign:e"
    ];
  };

  home.packages = [toggle-caps-swap];
}
