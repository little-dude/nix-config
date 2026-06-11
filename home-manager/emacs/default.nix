{pkgs, ...}: {
  home.packages = [
    pkgs.emacs-all-the-icons-fonts
    # pkgs.tree-sitter-grammars.tree-sitter-gleam
    pkgs.pyright
    pkgs.claude-agent-acp
    pkgs.flameshot
    pkgs.wl-clipboard
    # TypeScript / Svelte LSP servers and tooling. These are system binaries,
    # not emacs packages. `lsp-svelte` (built into lsp-mode) drives
    # svelte-language-server, which delegates TS work to typescript-language-server.
    pkgs.svelte-language-server
    pkgs.typescript-language-server
    pkgs.typescript # global tsc/tsserver fallback for projects without a local install
    pkgs.prettier # formatter used by apheleia for ts/tsx/svelte
  ];
  services.emacs.enable = true;
  programs.emacs = {
    enable = true;
    extraPackages = (
      epkgs: (with epkgs; [
        doom-modeline
        all-the-icons
        direnv
        gleam-ts-mode
        use-package
        use-package-chords
        magit
        corfu
        cape
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
        yasnippet
        lsp-mode
        lsp-pyright
        org-modern
        org-rich-yank
        org-download
        evil-org
        lsp-treemacs
        lsp-ui
        rustic
        auto-dim-other-buffers
        doom-themes
      rainbow-mode
        command-log-mode
        dockerfile-mode
        nix-mode
        vertico
        orderless
        marginalia
        consult
        embark
        embark-consult
        which-key
        helpful
        yaml-mode
        # we don't use helm but it's needed to display rust documentation
        # see: https://github.com/brotzeit/rustic#inline-documentation
        # helm-ag
        typst-ts-mode
        # TypeScript + Svelte development. typescript-ts-mode/tsx-ts-mode are
        # built into emacs; svelte-mode provides the .svelte major mode.
        # add-node-modules-path prefers a project's local node_modules/.bin so
        # its pinned prettier/eslint/tsserver versions win. apheleia formats
        # asynchronously on save (via prettier).
        svelte-mode
        add-node-modules-path
        apheleia
        (treesit-grammars.with-grammars (grammars: [
          grammars.tree-sitter-typst
          grammars.tree-sitter-typescript
          grammars.tree-sitter-tsx
        ]))
        ini-mode
        protobuf-mode
        yang-mode
        shell-maker
        acp
        agent-shell
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
    "Emacs.Font" = "Iosevka Nerd Font Mono-11";
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
    Exec=emacsclient -c %F
    Icon=emacs
    Type=Application
    Terminal=false
    Categories=Development;TextEditor;
    StartupWMClass=Emacs
    Keywords=Text;Editor;
  '';
}
