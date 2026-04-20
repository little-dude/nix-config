(global-set-key (kbd "C-c o a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)
(setq org-default-notes-file "~/notes/quick-notes.org")
(setq org-capture-templates
  '(("n" "Note" entry (file "~/notes/quick-notes.org")
     "* %?\n%U\n")))

(use-package org
  :ensure nil
  :after evil
  :config
  (setq org-return-follows-link t)
  (setq org-startup-indented t)
  (setq org-hide-emphasis-markers t)
  (setq org-startup-folded 'content)
  (setq org-todo-keywords
        '((sequence "TODO(t)" "IN-PROGRESS(i)" "BLOCKED(b)" "|" "DONE(d)" "CANCELLED(c)")))
  (setq org-use-fast-todo-selection 'auto))

(use-package org-tempo
  :demand t)

(use-package evil-org
  :after (evil org)
  :hook (org-mode . evil-org-mode)
  :config
  (require 'evil-org-agenda)
  (evil-org-set-key-theme '(navigation insert textobjects calendar))
  (evil-org-agenda-set-keys)
  (evil-define-key 'normal org-mode-map
    (kbd "C-c .") 'org-time-stamp
    (kbd "C-c !") 'org-time-stamp-inactive))

(use-package org-modern
  :after org
  :hook ((org-mode . org-modern-mode)
         (org-agenda-mode . org-modern-agenda)))

(use-package org-download
  :after (org evil)
  :hook ((org-mode . org-download-enable)
         (dired-mode . org-download-enable))
  :config
  (setq org-download-method 'directory)
  (setq org-download-image-dir "images")
  (setq org-download-heading-lvl nil)
  (setq org-download-timestamp "%Y%m%d-%H%M%S_")
  (setq org-download-screenshot-method "flameshot gui --raw > %s")
  (evil-define-key 'normal org-mode-map
    (kbd "C-c i c") 'org-download-clipboard
    (kbd "C-c i s") 'org-download-screenshot
    (kbd "C-c i y") 'org-download-yank
    (kbd "C-c i d") 'org-download-delete))

(use-package org-rich-yank
  :after (org evil)
  :config
  (evil-define-key 'normal org-mode-map
    "C-M-p" 'org-rich-yank))
