;; we keep our secrets in an encrypted file.
(setq auth-sources
    '((:source "~/.config/authinfo.gpg")))

(use-package magit
  :bind (("C-x g" . magit-status)))
