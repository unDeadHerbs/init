qemu-system-x86_64                                                    \
   -enable-kvm -cpu host -usb                                         \
   -drive file=/mnt/6/guix_hdd,format=raw                             \
   -device e1000,netdev=net0                                          \
   -netdev user,id=net0,hostfwd=tcp::5555-:22                         \
   -m 1G -monitor stdio                                               \
   -name "Guix"                                                       \
   "$@"

# -cdrom /mnt/6/guix-system-install-1.1.0.x86_64-linux.iso
#device_add usb-host,hostbus=1,hostaddr=20
