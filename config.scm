;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu)
	     (srfi srfi-1) ;for 'remove'
	     (gnu services sound))
(use-package-modules shells)
(use-service-modules desktop networking ssh xorg pm avahi dbus)

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
             (device (file-system-label "guix"))
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
	   ;; console-fonts
	   (service network-manager-service-type)
	   (service wpa-supplicant-service-type)
	   (service usb-modeswitch-service-type)
	   (service avahi-service-type)
	   ;; upower ; from gnome, havn't renabled
	   ;; (service accountsservice-service) ; TODO: What's this do?
	   ;; colord ; from gnome, havn't renabled
	   ;; (service geoclue-service)
	   (service dbus-root-service-type)
	   (service polkit-service-type)
	   ;; (service polkit-wheel-service-type) ; can't find in repo
	   (service elogind-service-type)
	   ;; (service ntp-service-type)
	   ;; x11-socket-directory
	   (service alsa-service-type)
	   (service tlp-service-type))
     %base-services)))
       
