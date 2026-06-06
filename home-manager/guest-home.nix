{
  outputs,
  pkgs,
  ...
}: {
  imports = [
    ./fish.nix      # shell + aliases, no personal data
    ./gnome.nix     # desktop tweaks, no personal data
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages
    ];
    config.allowUnfree = true;
  };

  home = {
    username = "guest";
    homeDirectory = "/home/guest";
    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
    };
    packages = with pkgs; [
      firefox
    ];
  };

  xdg.enable = true;
  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
