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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(custom-enabled-themes nil)
 '(diary-hook nil)
 '(erc-modules
   (quote
    (autojoin button completion dcc fill irccontrols list log match menu move-to-prompt netsplit networks noncommands readonly ring stamp track)))
 '(linum-relative-current-symbol "")
 '(org-agenda-files "~/.agenda_files")
 '(org-export-with-todo-keywords nil)
 '(org-trello-current-prefix-keybinding "C-c o" nil (org-trello))
 '(package-load-list (quote (all (ido nil))))
 '(package-selected-packages
   (quote
    (plantuml-mode geiser slime undo-tree bind-key rfc-mode erlang erlstack-mode pretty-mode nasm-mode powershell scad-mode haskell-mode magit ob-spice cider arduino-mode vagrant-tramp vagrant tramp-term smart-tabs-mode persistent-scratch package-utils org-trello org-preview-html org-plus-contrib org-dotemacs org-bullets ob-diagrams ob-async multiple-cursors mentor markdown-mode magit-tramp magit-popup magit-filenotify linum-relative highlight-parentheses highlight-indentation highlight-current-line highlight-blocks highlight hideshowvis gnu-elpa-keyring-update flymake-cursor flymake-cppcheck flycheck evil-visualstar dynamic-spaces ctags-update ctags cppcheck centered-cursor-mode auto-compile)))
 '(safe-local-variable-values
   (quote
    ((eval org-show-todo-tree
	   (quote nil))
     (eval flyspell-mode t)
     (indent-tabs-mode quote nil)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'magit-clean 'disabled nil)
(org-dotemacs-load-default)
