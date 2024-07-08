(use-modules (gnu)
             (gnu packages shells) ;; `zsh` location
             (gnu packages bash))
(use-service-modules
 desktop    ;; Login Manager
 networking
 telephony
 admin      ;; for `unattended-upgrade` 
 ssh        ;; `ssh` server
 ;; virtualization ;; cross-dev
 avahi)     ;; zeroconf

(operating-system
  (locale "en_US.utf8")
  (timezone "America/Chicago")
  (keyboard-layout (keyboard-layout "us"))
  (bootloader
    (bootloader-configuration
      (bootloader grub-bootloader)
      (targets '("/dev/sda"))
      (keyboard-layout keyboard-layout)))
  (swap-devices (list
                 (swap-space (target
                              (uuid "768b26c8-f49b-4c1c-be5e-b849b5a945f0")))))
  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device
               (uuid "a3e2798d-f1da-43bc-a3ee-b49e7d4ba9c3"
                     'ext4))
             (type "ext4"))
           %base-file-systems))
  (host-name "ptah")
  (users (cons* (user-account
                  (name "udh")
                  (comment "unDeadHerbs")
                  (group "users")
                  (home-directory "/home/udh")
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video"))
                  (shell #~(string-append #$zsh "/bin/zsh")))
               ; (user-account
               ;   (name "Vika")
               ;   (comment "")
               ;   (group "users")
               ;   (home-directory "/home/vika")
               ;   (supplementary-groups
               ;     '("wheel" "netdev" "audio" "video"))
               ;   (shell #~(string-append #$zsh "/bin/zsh")))
               ; (user-account
               ;   (name "Wizard")
               ;   (comment "")
               ;   (group "users")
               ;   (home-directory "/home/Wizard")
               ;   (supplementary-groups
               ;     '("wheel" "netdev" "audio" "video"))
               ;   (shell #~(string-append #$zsh "/bin/zsh")))
               ; (user-account
               ;   (name "tv3")
               ;   (comment "")
               ;   (group "users")
               ;   (home-directory "/home/tv3")
               ;   (supplementary-groups
               ;     '("wheel" "netdev" "audio" "video"))
               ;   (shell #~(string-append #$bash "/bin/bash")))
                %base-user-accounts))
  (packages
    (append
     (list
      ;(specification->package "i3-wm")
      (specification->package "bash")
      (specification->package "zsh")
      ;(specification->package "nss-certs")
      )
      %base-packages))
  (services
    (append
     (list
      ;; SSH Server
      (service openssh-service-type
               (openssh-configuration
                (x11-forwarding? #t)
                (password-authentication? #f)))
      ;; Graphical Login Manager
      ;(service gnome-desktop-service-type)
      ;(service xfce-desktop-service-type)

      ;; Networking      
      ;; In desktop-services
      (service dhcp-client-service-type)

      ;; Auto updates
      ;(service unattended-upgrade-service-type)

      (service ntp-service-type)

      ;; Servers
      ;;(service murmur-service-type
      ;;         (murmur-configuration
      ;;          (welcome-text
      ;;           "Welcome to this Mumble server running on Guix!")
      ;;                                  ;(cert-required? #t) ;disallow text password logins
      ;;          ))

      ;; Darknets
      (service tor-service-type)
      ;(service yggdrasil-service-type
      ;         (yggdrasil-configuration
      ;          (autoconf? #f) ;; use only the public peers
      ;          (json-config
      ;           ;; choose one from
      ;           ;; https://github.com/yggdrasil-network/public-peers
      ;           '((peers . #("tcp://140.238.168.104:17117" "tls://ygg-tx-us.incognet.io:8884"))))
      ;          ))

      ;; In desktop-services
      (service avahi-service-type)

      ;; Cross dev Compiler
      ;;(service libvirt-service-type
      ;;         (libvirt-configuration
      ;;          (unix-sock-group "libvirt")
      ;;          (tls-port "16555")))

      ;; Docker for V
      ;;(service docker-service-type)

      )
     ;%desktop-services)))

     %base-services
     ;(modify-services %base-services ;
     ;                 (guix-service-type
     ;                  config => (guix-configuration
     ;                            (inherit config)
     ;                            (substitute-urls
     ;                             (list "https://bp7o7ckwlewr4slm.onion"))
     ;                            (http-proxy "http://localhost:9250"))))
     )))
