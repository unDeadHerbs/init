;; This is an operating system configuration for Guix SD.

(use-modules (gnu)
	     (srfi srfi-1)              ; for 'remove'
	     ;; User Shell Location
	     (gnu packages shells)
	     (gnu packages ssh)
	     ;; Services
	     (gnu services sound)
	     (gnu services desktop)     ; for 'elogind' TODO: can the
	     				; scope be reduced on that?
	     (gnu services networking)
	     (gnu services pm)          ; power management
	     (gnu services avahi)
	     (gnu services ssh)
	     (gnu services dbus))

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
             (device "/dev/sda3")
             (type "ext4"))
           %base-file-systems))
  (host-name "guix-virt")
  (users (cons* (user-account
                  (name "udh")
                  (comment "unDeadHerbs")
                  (group "users")
                  (home-directory "/home/udh")
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video"))
                  (shell #~(string-append #$zsh "/bin/zsh")))
                %base-user-accounts))
  (packages (cons*
	     ;;; These are in long form to reduce `use-modules` lines.
	     ;; System
	     (specification->package "bash")
	     (specification->package "nss")
	     (specification->package "nss-certs")
	     (specification->package "tor")
	     (specification->package "wpa-supplicant")
	     (specification->package "zsh")
	     %base-packages))
  (name-service-switch %mdns-host-lookup-nss)
  (services
    (append
     (list (service network-manager-service-type)
	   ;(service tor-service-type)
	   (service wpa-supplicant-service-type)
	   (service usb-modeswitch-service-type)
	   (service avahi-service-type)
	   (service dbus-root-service-type)
	   (service polkit-service-type)
	   (service elogind-service-type)
	   (service ntp-service-type)
	   (service openssh-service-type)
	   ;(service alsa-service-type)
	   ) ;(service tlp-service-type)) ; Thermal
     %base-services)))

;; TODO: Improve the `console-fonts` config from this
;; #<<service> type: #<service-type console-fonts 7f506f7ae690>
;;            value: (("tty1" . "LatGrkCyr-8x16")
;;                    ("tty2" . "LatGrkCyr-8x16")
;;                    ("tty3" . "LatGrkCyr-8x16")
;;                    ("tty4" . "LatGrkCyr-8x16")
;;                    ("tty5" . "LatGrkCyr-8x16")
;;                    ("tty6" . "LatGrkCyr-8x16"))>
