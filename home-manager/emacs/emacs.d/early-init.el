;;; early-init.el --- Runs before init.el and package loading -*- lexical-binding: t; -*-

;; lsp-mode and its extensions (lsp-ui, lsp-treemacs) are compiled with
;; LSP_USE_PLISTS=true by the emacs package build (see default.nix), baking
;; plist accessors into their code. lsp-mode also reads this variable when it
;; loads to choose its runtime object representation. The compiled and runtime
;; choices must agree, so set it here, before any lsp code can load. A mismatch
;; corrupts every deserialized LSP response.
(setenv "LSP_USE_PLISTS" "true")

;;; early-init.el ends here
