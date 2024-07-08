(use-modules (gnu)
             (gnu packages shells) ;; `zsh` location
             (gnu packages bash) ;; since `bash` isn't in shell
             )
(use-service-modules
 networking
 admin      ;; for `unattended-upgrade` 
 ssh        ;; `ssh` server
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
  (file-systems (cons*
                 (file-system
                  (mount-point "/")
                  (device
                   (uuid "a3e2798d-f1da-43bc-a3ee-b49e7d4ba9c3"
                         'ext4))
                  (type "ext4"))
                 %base-file-systems))
  (host-name "ptah")
  (users (cons*
          (user-account
           (name "udh")
           (comment "unDeadHerbs")
           (group "users")
           (home-directory "/home/udh")
           (supplementary-groups
            '("wheel" "netdev" "audio" "video"))
           (shell #~(string-append #$zsh "/bin/zsh")))
          %base-user-accounts))
  (packages (cons*    
             (specification->package "bash")
             (specification->package "zsh")
             (specification->package "i3-wm") ; fixes x-forwarding (probably any wm will do)
             %base-packages))
  (services (cons*
             ;; SSH Server
             (service openssh-service-type
                      (openssh-configuration
                       (x11-forwarding? #t)
                       (password-authentication? #f)))
             ;; Networking      
             (service dhcp-client-service-type)
             (service avahi-service-type)
             (service tor-service-type)
             ;; Auto updates
             (service unattended-upgrade-service-type)
             ;; Time
             (service ntp-service-type)
             %base-services)))
