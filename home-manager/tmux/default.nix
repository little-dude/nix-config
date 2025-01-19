{ config, pkgs, ... }:
{
  home.packages = [ pkgs.powerline ];
  programs.tmux = {
    enable = true;
    extraConfig =
      ''
        run-shell "powerline-daemon -q"
        source ${pkgs.powerline}/share/tmux/powerline.conf
      ''
      + builtins.readFile ./tmux.conf;
  };

}
