# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
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
    ./ai.nix
    ./nix-utils.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;
  # Use pipewire instead of pulseaudio
  # pulseaudio is automatically enabled by some DEs
  # so for it to false here
  # https://github.com/NixOS/nixpkgs/issues/261320#issuecomment-1984160884
  services.pulseaudio.enable = lib.mkForce false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware = {
    bluetooth = {
      enable = true;
      # powers up the default Bluetooth controller on boot
      powerOnBoot = true;
    };
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
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
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = ["nix-command flakes"];
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
  systemd.services.clamav-freshclam.wants = ["network-online.target"];

  boot = {
    # try to disable the bell
    blacklistedKernelModules = [
      "snd_pcsp"
      "pcspkr"
    ];
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
    extraGroups = ["wheel"];
    shell = pkgs.bash;
  };
  programs.zsh.enable = true;
  programs.fish.enable = true;
  # First, we don't want to make fish the login shell so we start it from bash.
  # https://nixos.wiki/wiki/Fish#Setting_fish_as_your_shell
  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };
  # Prevent NixOS from adding ls aliases, because they leak into fish.
  # See https://discourse.nixos.org/t/fish-alias-added-by-nixos-cant-delete/19626
  environment.shellAliases = lib.mkForce {};
  # See: https://discourse.nixos.org/t/how-to-specify-programs-sqlite-for-command-not-found-from-flakes/22722/5
  programs.command-not-found.enable = false;

  environment.systemPackages = with pkgs; [
    pciutils
    lshw
    neovim
    firefox
    git
    xsel
    mlocate
    just
  ];

  services.sshd.enable = true;

  # To communicate with android. See: https://nixos.wiki/wiki/Android#adb_setup
  programs.adb.enable = true;

  security.wrappers.sniffnet = {
    source = "${pkgs.sniffnet}/bin/sniffnet";
    capabilities = "cap_net_raw,cap_net_admin=eip";
    owner = "root";
    group = "root";
    permissions = "u+rx,g+rx,o+rx";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
