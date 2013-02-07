;; -*- mode: emacs-lisp -*-
;; Simple .emacs configuration

;; ---------------------
;; -- Global Settings --
;; ---------------------
(require 'cl)
(require 'ido)
(setq show-trailing-whitespace t)
(menu-bar-mode -1)
(setq column-number-mode t)
(setq vc-follow-symlinks t)
(setq inhibit-startup-message t)
(normal-erase-is-backspace-mode 1)
(setq save-abbrevs nil)
(setq suggest-key-bindings t)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(ido-mode t)
(setq suggest-key-bindings t)
(setq vc-follow-symlinks t)

;; ------------
;; -- Macros --
;; ------------
(require "config-defuns.el")
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c;" 'comment-or-uncomment-region)
(global-set-key "\M-n" 'next5)
(global-set-key "\M-p" 'prev5)
(global-set-key "\M-o" 'other-window)
(global-set-key "\M-i" 'back-window)
(global-set-key "\C-z" 'zap-to-char)
(global-set-key "\C-h" 'backward-delete-char)
(global-set-key "\M-d" 'delete-word)
(global-set-key "\M-h" 'backward-delete-word)


;; ------------------------
;; -- Mode configuration --
;; ------------------------
(require "config-js.el")
