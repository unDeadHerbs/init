;;; init.el --- user init file      -*- no-byte-compile: t -*-

;;prevent warning that .dotemacs.org is symlink
(setq vc-follow-symlinks nil)

(require 'package)
(require 'cl-lib)
(unless (package-installed-p 'org-dotemacs)
  (progn
    (package-initialize)
    (setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			     ("melpa" . "http://melpa.org/packages/") ; milkyPostman's repo
			     ("org" . "https://orgmode.org/elpa/"))) ; Org-mode's repository
    (package-refresh-contents)
    (package-install 'org-dotemacs)
    (kill-buffer "*Compile-Log*")))
(require 'org-dotemacs)

;(custom-set-variables
; '(ansi-color-faces-vector
;   [default default default italic underline success warning error])
; '(ansi-color-names-vector
;   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
; '(custom-enabled-themes '(wheatgrass))
; '(erc-modules
;   '(autojoin button completion dcc fill irccontrols list log match menu move-to-prompt netsplit networks noncommands readonly ring stamp track))
; '(linum-relative-current-symbol "")
; '(org-agenda-files '("~/todo"))
; '(org-export-with-todo-keywords nil)
; '(package-load-list '(all (ido nil)))
; '(package-selected-packages
;   '(exwm guix pretty-sha-path rainbow-blocks openscad-mode scad-preview plantuml-mode geiser slime undo-tree bind-key rfc-mode erlang erlstack-mode pretty-mode nasm-mode powershell scad-mode haskell-mode magit ob-spice cider arduino-mode vagrant-tramp vagrant tramp-term smart-tabs-mode persistent-scratch package-utils org-preview-html org-plus-contrib org-dotemacs org-bullets ob-diagrams ob-async multiple-cursors mentor markdown-mode magit-tramp magit-popup magit-filenotify linum-relative highlight-parentheses highlight-indentation highlight-current-line highlight-blocks highlight hideshowvis gnu-elpa-keyring-update flymake-cursor flymake-cppcheck flycheck evil-visualstar dynamic-spaces ctags-update ctags cppcheck centered-cursor-mode auto-compile))
; '(safe-local-variable-values
;   '((eval org-show-todo-tree 'nil)
;     (eval flyspell-mode t)
;     (indent-tabs-mode quote nil))))
(put 'magit-clean 'disabled nil)
(org-dotemacs-load-default)
