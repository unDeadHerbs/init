(use-modules (gnu)
             (gnu packages shells)) ;; `zsh` location
(use-service-modules
 desktop    ;; TODO: What's this for?
 networking
 ssh        ;; `ssh` server
 avahi)     ;; zeroconf

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
               (uuid "473117fc-4800-4683-b368-921610db5895"
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
                %base-user-accounts))
  (packages
    (append
     (list
      (specification->package "zsh")
      (specification->package "tor")
      (specification->package "nss-certs"))
      %base-packages))
  (services
    (append
      (list (service openssh-service-type)
            (service network-manager-service-type)
            (service wpa-supplicant-service-type)
            (service tor-service-type
                     (tor-configuration
                      (config-file
                       (plain-file "tor-config"
                                   "HTTPTunnelPort 127.0.0.1:9250"))))
            (service avahi-service-type)
            )
      %base-services)))
