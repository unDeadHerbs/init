;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu)
	     (srfi srfi-1))  ;for 'remove'
(use-package-modules shells)
(use-service-modules desktop networking ssh xorg pm)

(operating-system
  (locale "en_US.utf8")
  (timezone "America/Chicago")
  (keyboard-layout
    (keyboard-layout "us" "altgr-intl"))
  (bootloader
    (bootloader-configuration
      (bootloader grub-bootloader)
      (target "/dev/sda")
      (keyboard-layout keyboard-layout)))
  (swap-devices (list "/dev/sda2"))
  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device
               (uuid "12985d57-6384-4943-9fdb-a1c2218813d6"
                     'ext4))
             (type "ext4"))
           %base-file-systems))
  (host-name "kitchensink")
  (users (cons* (user-account
                  (name "udh")
                  (comment "unDeadHerbs")
                  (group "users")
                  (home-directory "/home/udh")
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video"))
                  (shell #~(string-append #$zsh "/bin/zsh")))
                %base-user-accounts))
  (packages
    (append
      (list (specification->package "i3-wm")
            (specification->package "nss-certs"))
      %base-packages))
  (services
    (append
      (list (service openssh-service-type)
            (set-xorg-configuration
              (xorg-configuration
                (keyboard-layout keyboard-layout)))
	    (service tlp-service-type))
      (delq (list (service gdm-service-type))
	      %desktop-services))))
       
