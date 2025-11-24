{pkgs, ...}: {
  home.packages = [
    pkgs.emacs-all-the-icons-fonts
    # pkgs.tree-sitter-grammars.tree-sitter-gleam
    pkgs.tree-sitter-grammars.tree-sitter-typst
  ];
  services.emacs.enable = true;
  programs.emacs = {
    enable = true;
    extraPackages = (
      epkgs: (with epkgs; [
        doom-themes
        doom-modeline
        all-the-icons
        direnv
        gleam-ts-mode
        use-package
        use-package-chords
        markdown-toc
        magit
        company
        # See: https://github.com/tigersoldier/company-lsp/issues/147
        # company-lsp
        flycheck
        rg
        projectile
        evil
        evil-collection
        json-mode
        undo-tree
        rainbow-delimiters
        treemacs
        treemacs-evil
        treemacs-projectile
        treemacs-all-the-icons
        treemacs-magit
        lsp-mode
        lsp-treemacs
        lsp-ui
        rustic
        auto-dim-other-buffers
        atom-one-dark-theme
        command-log-mode
        dockerfile-mode
        nix-mode
        ivy
        ivy-rich
        counsel
        counsel-projectile
        swiper
        which-key
        helpful
        elpy
        yaml-mode
        # we don't use helm but it's needed to display rust documentation
        # see: https://github.com/brotzeit/rustic#inline-documentation
        # helm-ag
        typst-ts-mode
        ini-mode
        protobuf-mode
        yang-mode
      ])
    );
  };

  home.file = {
    ".emacs.d" = {
      source = ./emacs.d;
      recursive = true;
    };
  };

  xresources.properties = {
    # Set some Emacs GUI properties in the .Xresources file because they are
    # expensive to set during initialization in Emacs lisp. This saves about
    # half a second on startup time. See the following link for more options:
    # https://www.gnu.org/software/emacs/manual/html_node/emacs/Fonts.html#Fonts
    "Emacs.menuBar" = false;
    "Emacs.toolBar" = false;
    "Emacs.verticalScrollBars" = false;
    # If this is broken after fonts are updated:
    # - rebuild the fonts with `fc-cache -f` (https://github.com/nix-community/home-manager/issues/605)
    # - `rm -rf ~/.cache/fontconfig` (https://github.com/nix-community/emacs-overlay/issues/75)
    #
    # Useful emacs commands:
    # - describe the current font with `C-u C-x =`
    # - dynamically change the font: `M-x set-frame-font`
    #
    # Note that with iosevka the icons aren't found, not sure why. So
    # we just use hack for now.
    #
    # "Emacs.Font" = "-UKWN-Iosevka Nerd Font Propo-regular-normal-normal-*-15-*-*-*-*-0-iso10646-1";
    # "Emacs.Font" = "-SRC-Hack Nerd Font-regular-normal-normal-*-15-*-*-*-m-0-iso10646-1";
    "Emacs.Font" = "-CTDB-FiraCode Nerd Font-regular-normal-normal-*-*-*-*-*-m-0-iso10646-1";
  };

  # Home manager's emacs service doesn't provide a desktop entry for the emacs
  # client. Note the %F on the `Exec=` line passes any file name string to tell
  # emacs to open a file. I just use Albert to launch the emacs client so I
  # don't every really need that.
  xdg.dataFile."applications/emacsclient.desktop".text = ''
    [Desktop Entry]
    Name=Emacsclient
    GenericName=Text Editor
    Comment=Edit text
    MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
    Exec=emacsclient -c -a emacs %F
    Icon=emacs
    Type=Application
    Terminal=false
    Categories=Development;TextEditor;
    StartupWMClass=Emacs
    Keywords=Text;Editor;
  '';
}
