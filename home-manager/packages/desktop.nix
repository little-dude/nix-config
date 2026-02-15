{pkgs, ...}: {
  home.packages = with pkgs; [
    # browsers
    firefox
    google-chrome

    # communication
    signal-desktop
    discord

    # media
    vlc
    pavucontrol
    gimp

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
