(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(eval-when-compile
  (require 'use-package))

(load-file "~/.emacs.d/lisp/ui.el")
(load-file "~/.emacs.d/lisp/evil.el")
(load-file "~/.emacs.d/lisp/edit.el")
(load-file "~/.emacs.d/lisp/ide.el")
(load-file "~/.emacs.d/lisp/git.el")

;; TMP https://github.com/magit/magit/issues/5011
(defun seq-keep (function sequence)
  "Apply FUNCTION to SEQUENCE and return the list of all the non-nil results."
  (delq nil (seq-map function sequence)))

(use-package json-mode
  :mode ("\\.json$" . json-mode))

(use-package yaml-mode
  :mode ("\\.ya?ml$" . yaml-mode))

(use-package direnv
  :config
  ;; Ensures that external dependencies are available before they are
  ;; called. See: https://github.com/wbolster/emacs-direnv/issues/17
  (add-hook 'prog-mode-hook #'direnv--maybe-update-environment)
  (direnv-mode 1))

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package dockerfile-mode
  :config (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode)))

;; Allows to see which commands are being called:
;; - command-log-mode
;; - clm/open-command-log-buffer
(use-package command-log-mode)

(use-package rustic
  :config
  (setq rustic-lsp-server 'rust-analyzer)
  (unbind-key "C-c C-c C-t" rustic-mode-map)
  ;; when passing custom test args with rustic-test-arguments, we need
  ;; to run rustic-cargo-test-rerun instead of rustic-cargo-test
  ;;
  ;; To pass custom test args, add this to .dir-locals.el:
  ;; ((rustic-mode . ((rustic-test-arguments . "-- --skip integration"))))
  :bind (("C-c C-c C-t" . rustic-cargo-test-rerun)))

(use-package rg
  :config (rg-enable-default-bindings))

(use-package sql
  :config
  ;; with mariadb, the default regexp used to match the prompt is a bit off. This fixes it.
  (sql-set-product-feature 'mysql :prompt-regexp "^\\(MariaDB\\|MySQL\\) \\[[_a-zA-Z]*\\]> "))

(use-package undo-tree
  :init
  (setq undo-tree-auto-save-history t)
  (setq undo-tree-enable-undo-in-region nil)
  (setq undo-tree-history-directory-alist '(("." . "~/emacs.d/undo")))
  (global-undo-tree-mode))
