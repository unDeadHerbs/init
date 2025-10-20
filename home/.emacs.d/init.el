;;; init.el --- user init file      -*- no-byte-compile: t -*-

;; Prevent warning that .dotemacs.org is symlink
(setq vc-follow-symlinks nil)

;; Prevent startup question about my .dotemacs.org file's safety
(set 'safe-local-variable-values
     '((eval org-show-todo-tree 'nil)))

;; Disable IDO mode
;;
;; TODO: This line was scavenged from `customize`, see if it can be
;; moved to .dotemacs.org.
;(set 'package-load-list '(all (ido nil)))

(require 'package)
(require 'use-package)
(use-package org :pin gnu)
(unless (package-installed-p 'org-dotemacs)
  (progn
    (package-initialize)
    (setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			     ("melpa" . "http://melpa.org/packages/"))) ; milkyPostman's repo
			     ; ("org" . "https://orgmode.org/elpa/"))) ; Org-mode's repository
    (package-refresh-contents)
    (package-install 'org-dotemacs)
    (kill-buffer "*Compile-Log*")
    (let ((sig-state package-check-signature))
      (setq package-check-signature '())
      (package-install 'gnu-elpa-keyring-update)
      (setq package-check-signature sig-state))))
(if (package-installed-p 'org-roam)
		(progn
			(require 'org-roam)
			(setq org-roam-directory "~/org/roam/")
			(org-roam-db-sync)
			(org-roam-db-autosync-mode)))
(require 'org)
(require 'org-dotemacs)
(org-dotemacs-load-default)

(put 'upcase-region 'disabled nil)
