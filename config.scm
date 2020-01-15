;; This is an operating system configuration for Guix SD.

(use-modules (gnu)
	     (srfi srfi-1)             ; for 'remove'
	     ;; User Shell Location
	     (gnu packages shells)
	     ;; Services
	     (gnu services sound)
	     (gnu services desktop)
	     (gnu services networking)
	     (gnu services ssh)
	     (gnu services xorg)
	     (gnu services pm)         ; power management
	     (gnu services avahi)
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
  (packages (cons*
	     ;;; These are in long form to reduce `use-modules` lines.
	     ;;; These sections are listed in reverse order of importance.
	     ;; GUI-Fonts
	     (specification->package "font-gnu-unifont")
	     (specification->package "font-google-roboto")
	     (specification->package "font-fira-code")
	     (specification->package "font-fira-mono")
	     (specification->package "font-fira-sans")
	     (specification->package "libxfont")
	     ;; GUI
	     (specification->package "dmenu")
	     (specification->package "feh")
	     (specification->package "i3-wm")
	     (specification->package "i3status")
	     (specification->package "xf86-input-libinput")
	     (specification->package "xf86-video-fbdev")
	     (specification->package "xf86-video-nouveau")
	     (specification->package "xfce4-terminal")
	     (specification->package "xinit")
	     (specification->package "xorg-server")
	     ;; System
	     (specification->package "bash")
	     (specification->package "clang")
	     (specification->package "nss-certs")
	     (specification->package "tor")
	     (specification->package "wpa-supplicant")
	     (specification->package "zsh")
	     %base-packages))
  (services
    (append
     (list (service openssh-service-type)
	   (service network-manager-service-type)
	   (service tor-service-type)
	   (service wpa-supplicant-service-type)
	   (service usb-modeswitch-service-type)
	   (service avahi-service-type)
	   ;; (service accountsservice-service) ; TODO: What's this do?
	   ;; (service geoclue-service)
	   (service dbus-root-service-type)
	   (service polkit-service-type)
	   (service elogind-service-type)
	   ;; (service ntp-service-type)
	   ;; x11-socket-directory
	   (service alsa-service-type)
	   (service tlp-service-type))
     %base-services)))

;; TODO: Improve the `console-fonts` config from this
;; #<<service> type: #<service-type console-fonts 7f506f7ae690>
;;            value: (("tty1" . "LatGrkCyr-8x16")
;;                    ("tty2" . "LatGrkCyr-8x16")
;;                    ("tty3" . "LatGrkCyr-8x16")
;;                    ("tty4" . "LatGrkCyr-8x16")
;;                    ("tty5" . "LatGrkCyr-8x16")
;;                    ("tty6" . "LatGrkCyr-8x16"))>
