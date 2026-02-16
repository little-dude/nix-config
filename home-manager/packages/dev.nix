{pkgs, ...}: {
  home.packages = with pkgs; [
    # editors
    zed-editor
    television

    # git tools
    gh
    hub
    nix-prefetch-github

    # nix tools
    nix-output-monitor
    alejandra

    # shell
    shellcheck

    # database
    pgcli
    pgformatter
  ];
}
