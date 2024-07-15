# this isn't a real sell script, it's the list of commands I ran

sudo su
echo 0 > /proc/sys/kernel/hung_task_timeout_secs
fallocate -l 4G /swapfile
chmod 0600 /swapfile 
swapon /swapfile
exit
sudo cp wall_base.nix  /etc/nixos/configuration.nix
sudo nixos-rebuild boot
sudo reboot
