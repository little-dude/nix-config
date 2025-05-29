# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    ./hardware-configuration.nix
    ./nvidia.nix
    ./accelerated-video-playback.nix
    ./power-management.nix
    ./xserver.nix
    ./virtualization.nix
    ./printing.nix
    ./steam.nix
    ./on-the-go.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;
  hardware = {
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };
    bluetooth = {
      enable = true;
      # powers up the default Bluetooth controller on boot
      powerOnBoot = true;
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users.little-dude = import ../home-manager/home.nix;
    # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
  };

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages

      (import inputs.emacs-overlay)

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

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = [ "nix-command flakes" ];
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  # FIXME: https://github.com/StevenBlack/hosts#nix-flake

  networking.hostName = "system76-laptop";

  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };
  systemd.services.clamav-freshclam.wants = [ "network-online.target" ];

  boot = {
    # try to disable the bell
    blacklistedKernelModules = [ "snd_pcsp" "pcspkr" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.little-dude = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    pciutils
    lshw
    neovim
    firefox
    git
    xsel
  ];

  services.sshd.enable = true;

  # To communicate with android. See: https://nixos.wiki/wiki/Android#adb_setup
  programs.adb.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
