;; All the packages that turn emacs into a full-blown IDE with code completion, linting, etc.

(use-package company
  :commands company-tng-configure-default
  :custom
  ;; delay to start completion
  (company-idle-delay 0.5)
  ;; nb of chars before triggering completion
  (company-minimum-prefix-length 3)

  :config
  ;; enable company-mode in all buffers
  (global-company-mode)

  :bind
  ;; use <C> instead of <M> to navigate completions
  (:map company-active-map
	      ("M-n" . nil)
	      ("M-p" . nil)
	      ("C-n" . #'company-select-next)
	      ("C-p" . #'company-select-previous)))

(use-package projectile
  :commands projectile-mode
  :init
  (projectile-mode +1)
  ;; :config
  ;; (counsel-projectile-mode)
  :bind
  (:map projectile-mode-map
        ;; Not sure I want to use Super in emacs, since I use it a lot in gnome
        ;; ("s-p" . projectile-command-map)
        ("C-c p" . projectile-command-map)))

(use-package counsel-projectile
  :init (counsel-projectile-mode +1))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :diminish lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (gleam-ts-mode . lsp-deferred)
  :config
  (lsp-enable-which-key-integration t))

;; https://github.com/MasseR/nix-conf-emacs/commit/f4287c2b34128b0dde61f58ada4e474e1ed096dc
(use-package lsp-completion
  :config
  (lsp-inline-completion-mode))

(use-package lsp-ui
  :commands lsp-ui-mode)

(use-package flycheck
  :commands global-flycheck-mode
  :init
  (setq flycheck-mode-globals '(not rust-mode rustic-mode))
  (global-flycheck-mode))

(use-package yang-mode)

(use-package elpy
  :ensure t
  :defer t
  :init
  (advice-add 'python-mode :before 'elpy-enable))

(use-package gleam-ts-mode
  :mode (rx ".gleam" eos))
;; TODO: automatically install the tree sitter grammar:
;; See:
;; - https://nohzafk.github.io/posts/2024-06-21-use-gleam-ts-mode-in-doom-emacs/
;; - https://discourse.doomemacs.org/t/difference-between-after-and-after/3489/2
;;
;; (after! gleam-ts-mode
;;   (unless (treesit-language-available-p 'gleam)
;;     ;; compile the treesit grammar file the first time
;;     (gleam-ts-install-grammar)))
;;
;; FIXME: I can't get this to work.
;;
;; (add-hook 'gleam-ts-mode-hook
;;           (lambda () (add-hook 'before-save-hook 'gleam-format nil t)))
