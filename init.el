;;; init.el --- user init file      -*- no-byte-compile: t -*-

;;prevent warning that .dotemacs.org is symlink
(setq vc-follow-symlinks nil)

(require 'package)
(require 'cl-lib)
(package-initialize)
(unless (package-installed-p 'org-dotemacs)
  (progn
    (setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			     ("melpa" . "http://melpa.org/packages/") ; milkyPostman's repo
			     ("org" . "https://orgmode.org/elpa/"))) ; Org-mode's repository
    (package-refresh-contents)
    (package-install 'org-dotemacs)
    (kill-buffer "*Compile-Log*")))
(require 'org-dotemacs)
(org-dotemacs-load-default)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(erc-modules
   (quote
    (autojoin button completion dcc fill irccontrols list log match menu move-to-prompt netsplit networks noncommands readonly ring stamp track)))
 '(org-agenda-files (quote ("~/todo")))
 '(org-trello-current-prefix-keybinding "C-c o" nil (org-trello)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'magit-clean 'disabled nil)
