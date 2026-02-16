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

;; lsp-mode uses yasnippet to expand snippet completions (e.g. function signatures with placeholders).
;; Without it, those completions silently fail.
(use-package yasnippet
  :hook (lsp-mode . yas-minor-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :diminish lsp-mode
  :init
  (setq
   lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t)
  :custom
  (lsp-disabled-clients '(pylsp))
  :hook ((gleam-ts-mode . lsp-deferred)
         (python-ts-mode . (lambda ()
                             (direnv-update-environment)
                             (lsp-deferred))))
)

(use-package lsp-pyright
  :hook (python-ts-mode . (lambda () (require 'lsp-pyright))))

(use-package lsp-ui
  :commands lsp-ui-mode)

(use-package flycheck
  :commands global-flycheck-mode
  :init
  (setq flycheck-mode-globals '(not rust-mode rustic-mode))
  (global-flycheck-mode))

(use-package yang-mode)

(use-package gleam-ts-mode
  :mode (rx ".gleam" eos))
