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
(set 'package-load-list '(all (ido nil)))

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
(org-dotemacs-load-default)

;(custom-set-variables
; '(ansi-color-faces-vector
;   [default default default italic underline success warning error])
; '(ansi-color-names-vector
;   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
; '(custom-enabled-themes '(wheatgrass))
; '(erc-modules
;   '(autojoin button completion dcc fill irccontrols list log match menu move-to-prompt netsplit networks noncommands readonly ring stamp track))
; '(linum-relative-current-symbol "")
