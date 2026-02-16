(use-package use-package-chords
  :config
  (key-chord-mode 1)
  ;; The default value is 0.1 but it's a bit short. The problem is
  ;; that it kinda feels slow when moving with `j` or `k` if we set it
  ;; to 0.2. We're basically experiencing this:
  ;; https://github.com/emacs-evil/evil/issues/69
  (setq key-chord-two-keys-delay 0.2)
  ;; This seems to make things better
  (setq key-chord-safety-interval-forward 0.1))

(use-package evil
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  (setq evil-esc-delay 0)
  (setq evil-undo-system 'undo-tree)
  :chords (("jk" . evil-normal-state)
           ("kj" . evil-normal-state))
  :config
  (evil-mode 1)
  (setq evil-symbol-word-search t)
  ;; Use vim-like search.
  (evil-select-search-module 'evil-search-module 'evil-search)
  (define-key evil-normal-state-map "s" nil)
  (define-key evil-normal-state-map (kbd "ss") 'evil-window-split)
  (define-key evil-normal-state-map (kbd "sv") 'evil-window-vsplit)
  (define-key evil-normal-state-map (kbd "sr") 'evil-window-rotate-downwards)

  (define-key evil-normal-state-map (kbd "M-h") 'evil-window-left)
  (define-key evil-normal-state-map (kbd "M-j") 'evil-window-down)
  (define-key evil-normal-state-map (kbd "M-k") 'evil-window-up)
  (define-key evil-normal-state-map (kbd "M-l") 'evil-window-right)

  (define-key evil-normal-state-map (kbd "C-M-h") 'evil-window-move-far-left)
  (define-key evil-normal-state-map (kbd "C-M-j") 'evil-window-move-very-bottom)
  (define-key evil-normal-state-map (kbd "C-M-k") 'evil-window-move-very-top)
  (define-key evil-normal-state-map (kbd "C-M-l") 'evil-window-move-far-right)

  (define-key evil-normal-state-map (kbd "C-=") 'balance-windows)
  (define-key evil-normal-state-map (kbd "C-s z") 'delete-other-windows)

  )

;; Treat _ and - as word characters in evil word motions.
;; See https://emacs.stackexchange.com/a/9584/22105
(defun my/evil-word-motion-with-underscores (orig-fn &rest args)
  (let ((table (copy-syntax-table (syntax-table))))
    (modify-syntax-entry ?_ "w" table)
    (modify-syntax-entry ?- "w" table)
    (with-syntax-table table (apply orig-fn args))))

(dolist (fn '(evil-inner-word
              evil-a-word
              evil-forward-word-begin
              evil-forward-word-end
              evil-backward-word-begin
              evil-backward-word-end))
  (advice-add fn :around #'my/evil-word-motion-with-underscores))

(use-package evil-collection
  :custom (evil-collection-setup-minibuffer t)
  :after evil
  :config
  (evil-collection-init))
