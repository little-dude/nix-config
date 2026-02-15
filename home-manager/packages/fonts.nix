{pkgs, ...}: {
  home.packages = with pkgs; [
    nerd-fonts.hack
    nerd-fonts.iosevka
    nerd-fonts.fira-code
  ];
}
