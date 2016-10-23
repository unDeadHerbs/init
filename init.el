;;https://github.com/vapniks/org-dotemacs

;prevent warning that .dotemacs.org is symlink
(setq vc-follow-symlinks nil)

(require 'package)
(package-initialize)
(unless (package-installed-p 'org-dotemacs)
  (progn
    (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			     ("marmalade" . "https://marmalade-repo.org/packages/")
			     ("melpa" . "http://melpa.org/packages/") ; milkyPostman's repo
			     ("org" . "http://orgmode.org/elpa/"))) ; Org-mode's repository
    (package-refresh-contents)
    (package-install 'org-dotemacs)
    (kill-buffer "*Compile-Log*")))
(require 'cl-lib)
(require 'org-dotemacs)
(org-dotemacs-load-default)
;(org-dotemacs-load-file "/home/udh/.emacs.d/init.org")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("~/todo"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
