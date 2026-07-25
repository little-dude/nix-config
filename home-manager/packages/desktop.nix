{pkgs, ...}: {
  home.packages = with pkgs; [
    # browsers
    firefox
    google-chrome

    # communication
    signal-desktop
    discord
    slack
    element-desktop

    # media
    vlc
    pavucontrol
    gimp
    obs-studio

    # office & documents
    libreoffice-fresh
    evince
    calibre
    xournalpp
    joplin
    joplin-desktop

    # utilities
    transmission_4-gtk
  ];
}
