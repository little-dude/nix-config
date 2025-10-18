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

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # fonts
    nerd-fonts.hack
    nerd-fonts.iosevka
    nerd-fonts.fira-code

    neofetch

    # archives
    zip
    xz
    unzip
    p7zip
    gnutar
    zstd

    television # Fuzzy finding in zed: https://github.com/zed-industries/zed/discussions/22581
    zed-editor

    # cli tools
    gh
    bat
    hub
    ripgrep
    du-dust
    eza
    tokei
    xan
    fd
    tmux
    htop
    dfc
    jq # A lightweight and flexible command-line JSON processor
    pandoc
    texlive.combined.scheme-full
    pdftk
    pdfchain
    qpdf
    exiftool
    poppler-utils
    img2pdf

    napari

    # networking tools
    sniffnet
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    glow # markdown previewer in terminal

    btop # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb

    firefox
    google-chrome
    evince
    signal-desktop
    joplin
    joplin-desktop
    lshw
    nix-prefetch-github
    xournalpp

    yt-dlp
    xsel
    file

    wireshark-qt
    pavucontrol
    calibre
    discord
    vlc
    dia
    gimp
    libreoffice-fresh
    transmission_4-gtk
  ];
}
