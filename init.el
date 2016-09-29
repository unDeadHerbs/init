;;https://github.com/vapniks/org-dotemacs

;prevent warning that .dotemacs.org is symlink
(setq vc-follow-symlinks nil)

					;(require 'org-dotemacs)
(load-file "~/.emacs.d/elpa/org-dotemacs-0.3/org-dotemacs.el")
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
