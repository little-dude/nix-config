;;; early-init.el --- Runs before init.el and package loading -*- lexical-binding: t; -*-

;; lsp-mode plists (LSP_USE_PLISTS) are NOT enabled. Turning them on requires
;; the lsp-mode/lsp-protocol byte-compilation to also use plists, and the
;; emacs package build here compiles them for hash-tables regardless of the
;; env var. Setting LSP_USE_PLISTS at runtime without a matching build makes
;; lsp call gethash on plists and crash while parsing server responses.

;;; early-init.el ends here
