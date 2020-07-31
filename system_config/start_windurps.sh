qemu-system-x86_64                                                    \
   -enable-kvm -cpu host -usb                                         \
   -drive file=/dev/disk/by-id/ata-360G_SSD_03242218F0211,format=raw  \
   -drive file=/dev/disk/by-id/wwn-0x5000cca229c61649,format=raw      \
   -net nic                                                           \
   -net user,hostname=windows                                         \
   -m 3G -monitor stdio                                               \
   -name "Windows"

#device_add usb-host,hostbus=1,hostaddr=20
