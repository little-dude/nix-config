;; All the packages that turn emacs into a full-blown IDE with code completion, linting, etc.

(use-package corfu
  :custom
  ;; delay to start completion
  (corfu-auto-delay 0.5)
  ;; nb of chars before triggering completion
  (corfu-auto-prefix 3)
  (corfu-auto t)
  :custom-face
  (corfu-annotations ((t (:foreground "gray50" :slant italic :underline nil))))
  :init
  (global-corfu-mode)
  :bind
  ;; use <C> instead of <M> to navigate completions
  (:map corfu-map
        ("M-n" . nil)
        ("M-p" . nil)
        ("C-n" . #'corfu-next)
        ("C-p" . #'corfu-previous)))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file))

(use-package projectile
  :commands projectile-mode
  :init
  (projectile-mode +1)
  :bind
  (:map projectile-mode-map
        ("C-c p" . projectile-command-map))
  :config
  (projectile-load-known-projects))

;; lsp-mode uses yasnippet to expand snippet completions (e.g. function signatures with placeholders).
;; Without it, those completions silently fail.
(use-package yasnippet
  :hook (lsp-mode . yas-minor-mode))

(use-package lsp-mode
  :commands lsp
  :diminish lsp-mode
  :init
  (setq
   lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t)
  :custom
  (lsp-disabled-clients '(pylsp))
  ;; let Corfu drive completion-at-point instead of lsp-mode's own company glue
  (lsp-completion-provider :none)
  :hook ((python-ts-mode . (lambda ()
                             (direnv-update-environment)
                             (lsp-deferred))))
)

;; Tailwind CSS LSP. lsp-tailwindcss ships with lsp-mode and launches the server
;; as `node <server-path> --stdio`; with no path it builds a broken `node
;; --stdio` (the error we saw on .css/.svelte buffers once the project adopted
;; Tailwind). Point it at the nix-provided binary and run it as an add-on so it
;; coexists with the svelte/ts servers; if the binary is somehow missing, disable
;; the client so it stays quiet instead of failing to spawn.
(with-eval-after-load 'lsp-mode
  (require 'lsp-tailwindcss)
  (let ((server (executable-find "tailwindcss-language-server")))
    (if server
        (setq lsp-tailwindcss-add-on-mode t
              lsp-tailwindcss-server-path server)
      (add-to-list 'lsp-disabled-clients 'tailwindcss)))
  ;; lsp-tailwindcss-major-modes doesn't list svelte-mode by default.
  (add-to-list 'lsp-tailwindcss-major-modes 'svelte-mode))

(use-package lsp-pyright
  :hook (python-ts-mode . (lambda () (require 'lsp-pyright))))

(use-package lsp-ui
  :commands lsp-ui-mode)

(use-package flycheck
  :commands global-flycheck-mode
  :init
  (setq flycheck-mode-globals '(not rust-mode rustic-mode))
  (global-flycheck-mode))

(use-package typst-ts-mode
  :after evil
  :mode ("\\.typ\\'" "\\.typst\\'")
  :custom
  (typst-ts-mode-watch-options "--open")
  :hook (typst-ts-mode . (lambda ()
                           (lsp-deferred))))

;; TypeScript / TSX. typescript-ts-mode and tsx-ts-mode are built into emacs
;; (need the tree-sitter grammars, provided via nix). Remap the classic modes to
;; the tree-sitter ones and start lsp (typescript-language-server).
(use-package typescript-ts-mode
  :mode (("\\.ts\\'" . typescript-ts-mode)
         ("\\.mts\\'" . typescript-ts-mode)
         ("\\.cts\\'" . typescript-ts-mode)
         ("\\.tsx\\'" . tsx-ts-mode))
  :hook ((typescript-ts-mode . (lambda ()
                                 (direnv-update-environment)
                                 (lsp-deferred)))
         (tsx-ts-mode . (lambda ()
                          (direnv-update-environment)
                          (lsp-deferred)))))

;; Svelte. svelte-mode is the .svelte major mode; lsp-svelte (bundled with
;; lsp-mode) drives svelte-language-server.
(use-package svelte-mode
  :mode "\\.svelte\\'"
  :hook (svelte-mode . (lambda ()
                         (direnv-update-environment)
                         (lsp-deferred))))

;; Prefer the project-local node_modules/.bin (pinned prettier, eslint,
;; typescript, etc.) over globally installed tools.
(use-package add-node-modules-path
  :hook ((typescript-ts-mode tsx-ts-mode svelte-mode) . add-node-modules-path))

;; Asynchronous format-on-save via prettier.
(use-package apheleia
  :init (apheleia-global-mode +1)
  :config
  (dolist (mode '(typescript-ts-mode tsx-ts-mode svelte-mode))
    (setf (alist-get mode apheleia-mode-alist) 'prettier)))

(use-package yang-mode
  :after evil)
