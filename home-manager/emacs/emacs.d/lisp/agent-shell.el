(use-package agent-shell
  :after evil
  :commands (agent-shell)
  :bind (("C-c a" . agent-shell))
  :custom
  (agent-shell-session-restore-verbosity 'full)
  :config
  ;; Evil state-specific RET behavior: insert mode = newline, normal mode = send
  (evil-define-key 'insert agent-shell-mode-map (kbd "RET") #'newline)
  (evil-define-key 'insert agent-shell-mode-map (kbd "<C-return>") #'comint-send-input)
  (evil-define-key 'normal agent-shell-mode-map (kbd "RET") #'comint-send-input)
  (evil-define-key 'normal agent-shell-mode-map (kbd "<C-return>") #'comint-send-input)
  (evil-define-key 'normal agent-shell-mode-map (kbd "TAB") #'agent-shell-next-item)
  (evil-define-key 'normal agent-shell-mode-map (kbd "<backtab>") #'agent-shell-previous-item)

  ;; Configure *agent-shell-diff* buffers to start in Emacs state
  (add-hook 'diff-mode-hook
            (lambda ()
              (when (string-match-p "\\*agent-shell-diff\\*" (buffer-name))
                (evil-emacs-state)))))
