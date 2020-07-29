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
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(custom-enabled-themes nil)
 '(erc-modules
   (quote
    (autojoin button completion dcc fill irccontrols list log match menu move-to-prompt netsplit networks noncommands readonly ring stamp track)))
 '(linum-relative-current-symbol "")
 '(org-agenda-files (quote ("~/todo")))
 '(org-export-with-todo-keywords nil)
 '(org-trello-current-prefix-keybinding "C-c o" nil (org-trello))
 '(package-selected-packages
   (quote
    (ob-spice cider arduino-mode yasnippet vagrant-tramp vagrant tramp-term smart-tabs-mode persistent-scratch package-utils org-trello org-preview-html org-plus-contrib org-dotemacs org-bullets ob-diagrams ob-async multiple-cursors mentor markdown-mode magit-tramp magit-popup magit-filenotify linum-relative highlight-parentheses highlight-indentation highlight-current-line highlight-blocks highlight hideshowvis gnu-elpa-keyring-update flymake-cursor flymake-cppcheck flycheck evil-visualstar dynamic-spaces ctags-update ctags cppcheck centered-cursor-mode auto-compile))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'magit-clean 'disabled nil)
