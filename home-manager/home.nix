{
  outputs,
  pkgs,
  ...
}: {
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    ./packages
    ./nvim
    ./tmux
    ./git
    ./fish.nix
    ./zsh
    ./emacs
    ./gnome.nix
  ];

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    config.allowUnfree = true;
  };

  home = {
    username = "little-dude";
    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
    };
  };

  xdg = {
    enable = true;
    mime.enable = true;
  };

  programs.nix-index.enable = true;
  programs.nix-index.enableFishIntegration = true;

  programs.direnv = {
    enable = true;
    # This is enabled by default
    # enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  fonts.fontconfig.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
