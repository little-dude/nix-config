{ pkgs, ... }: {
  # Treemacs requires python3
  home.packages = [ pkgs.python3 pkgs.emacs-all-the-icons-fonts ];
  services.emacs.enable = true;
  # Used by grip-mode
  programs.emacs = {
    enable = true;
    extraPackages = (epkgs:
      (with epkgs; [
        markdown-toc
        grip-mode
        doom-themes
        doom-modeline
        all-the-icons
        mix
        direnv
        use-package
        use-package-chords
        magit
        company
        # See: https://github.com/tigersoldier/company-lsp/issues/147
        # company-lsp
        flycheck
        es-mode
        elpy
        rg
        vimrc-mode
        projectile
        evil
        evil-collection
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
        yaml-mode
        # we don't use helm but it's needed to display rust documentation
        # see: https://github.com/brotzeit/rustic#inline-documentation
        helm-ag
        ini-mode
        protobuf-mode
        rjsx-mode
        prettier
        tide
        typescript-mode
        web-mode
        sqlformat
        yang-mode
      ]));
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
    "Emacs.Font" =
      "-CYEL-Iosevka-normal-normal-normal-*-16-*-*-*-d-0-iso10646-1";
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
