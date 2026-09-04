;;; -*- lexical-binding: t; -*-
;; disable hard tabs
(setq-default indent-tabs-mode nil)
;; default tab width is 4, not 8
(setq-default tab-width 4)
;; make TAB actually insert a tab instead of auto-indenting the current line
(setq-default tab-always-indent nil)

(put 'downcase-region 'disabled nil)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
