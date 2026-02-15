{pkgs, ...}: {
  home.packages = with pkgs; [
    # archives
    zip
    xz
    unzip
    p7zip
    gnutar
    zstd

    # core cli tools
    bat
    ripgrep
    dust
    eza
    fd
    tmux
    htop
    btop
    jq
    file

    # document processing
    pandoc
    typst
    pdftk
    pdfchain
    qpdf
    exiftool
    poppler-utils
    img2pdf
    glow

    # system monitoring
    iotop
    iftop
    strace
    ltrace
    lsof
    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils
    lshw

    # misc
    neofetch
    xsel
    yt-dlp
    tokei
    xan
  ];
}
