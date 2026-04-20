;; ============================ General emacs settings ============================
;; maximize the emacs window on startup
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; Disable startup screen
(setq inhibit-startup-screen t)

;; Disable menu-bar, tool-bar, and scroll-bar.
(if (fboundp 'menu-bar-mode)
    (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1))

;; Make *scratch* buffer blank
(setq initial-scratch-message "")

;; Make window title the buffer name
(setq-default frame-title-format '("%b"))

;; Display line number except for certain modes
(global-display-line-numbers-mode t) ; requires emacs 26
(dolist (mode '(message-buffer-mode-hook
                treemacs-mode-hook
                magit-status-mode-hook
                org-mode-hook
                term-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Display column number
(column-number-mode)

;; highlight the line where the cursor is
(global-hl-line-mode +1)

;; Avoid littering the user's filesystem with backups
(setq backup-by-copying t             ; don't clobber symlinks
      backup-directory-alist
      '((".*" . "~/.emacs.d/saves/")) ; don't litter my fs tree
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)       ; use versioned backups

;; Lockfiles unfortunately cause more pain than benefit
(setq create-lockfiles nil)

(use-package typst-ts-mode
  :after evil
  :custom
  (typst-ts-mode-watch-options "--open"))

;; =============================== Theme ===============================
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-snazzy t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config)
  (doom-themes-treemacs-config)
  ;; override theme faces after loading — grouped here so they're easy to find.
  ;; NOTE: must use custom-set-faces (not use-package :custom-face) because
  ;; load-theme clears face-override-spec set by :custom-face.
  (custom-set-faces
   ;; search — theme defaults are too saturated (#3c8bb2 bg + red fg)
   '(lazy-highlight ((t (:background "#33353f" :weight bold))))
   '(isearch ((t (:background "#3e4150" :weight bold :underline t))))
   ;; highlight — bright cyan (#57c7ff) is distracting in minibuffer completions
   '(highlight ((t (:background "#3e4150"))))
   ;; lsp — symbol occurrences: theme bg (#365972) is too flashy
   '(lsp-face-highlight-textual ((t (:foreground "#ff5c57" :weight bold :slant italic :background "#282a36"))))
   ;; lsp-ui-doc — drop region inherit to avoid ugly bg on hovered symbol
   '(lsp-ui-doc-highlight-hover ((t (:inherit nil :background "#282a36" :weight bold :foreground "#ff5c57"))))
   ;; lsp-ui-doc — match code bg so tooltip blends in (tooltip default is darker)
   '(lsp-ui-doc-background ((t (:background "#282a36"))))
   '(lsp-ui-doc-header ((t (:foreground "#f3f99d" :background "#33353f" :weight bold))))
   ;; markdown — code blocks in lsp-ui tooltips had gray (#78787e) bg
   '(markdown-code-face ((t (:background "#282a36"))))
   ;; magit — subtler diff backgrounds (theme defaults are too saturated)
   '(magit-diff-added ((t (:background "#2a3325" :foreground "#57c28d"))))
   '(magit-diff-removed ((t (:background "#332228" :foreground "#c27070"))))
   '(magit-diff-added-highlight ((t (:background "#2f3b2a" :foreground "#6dd9a0"))))
   '(magit-diff-removed-highlight ((t (:background "#3b272d" :foreground "#d98585"))))
   ;; magit — brighten unchanged lines for better contrast
   '(magit-diff-context ((t (:foreground "#c0c0c0"))))
   '(magit-diff-context-highlight ((t (:foreground "#e0e0e0" :background "#242631"))))
   ;; rainbow-delimiters
   '(rainbow-delimiters-unmatched-face ((t (:background "dark gray" :foreground "red"))))
   '(rainbow-delimiters-depth-1-face ((t (:foreground "wheat"))))))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

;; ;; we highlight the current line, but it's too pale with doom-one so we override it here
;; (set-face-background hl-line-face "gray0")

;; colorize hex color strings in buffers
(use-package rainbow-mode
  :hook (help-mode . rainbow-mode))

;; colorful parenthesis
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
(show-paren-mode 1)
(setq show-paren-delay 0)

(use-package all-the-icons)

;; ======================== Treemacs ========================
(use-package treemacs-all-the-icons)

(use-package treemacs
  :config
  (setq treemacs-show-cursor nil)
  (treemacs-load-theme "all-the-icons")
  :bind
  (([f9] . treemacs)))

(use-package treemacs-evil
  :after treemacs evil
  :bind
   (("M-l" . evil-window-right)))

(use-package treemacs-projectile
  :after treemacs projectile)

(use-package treemacs-magit
  :after treemacs magit)

(use-package auto-dim-other-buffers
  :commands auto-dim-other-buffers-mode
  :diminish auto-dim-other-buffers-mode
  :init (auto-dim-other-buffers-mode))

(use-package uniquify
  :config
  (setq uniquify-buffer-name-style 'forward)
  (setq uniquify-separator "/")
  (setq uniquify-after-kill-buffer-p t)     ; rename after killing uniquified
  (setq uniquify-ignore-buffers-re "^\\*")) ; don't muck with special buffers

;; ======================== Ivy ========================
(use-package ivy
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  ;; by default, the regexp used by ivy starts with ^, which is
  ;; annoying. See:
  ;; https://emacs.stackexchange.com/a/38842/22105
  (setq ivy-initial-inputs-alist nil))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.2))

(use-package counsel
  :after ivy
  :config
  (counsel-mode)
  :bind ((:map minibuffer-local-map ("C-r" . 'counsel-minibuffer-history))))

(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)
         ("C-r" . swiper)))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . helpful-function)
  ([remap describe-symbol] . helpful-symbol)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-command] . helpful-command)
  ([remap describe-key] . helpful-key))
