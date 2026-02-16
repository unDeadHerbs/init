#!/usr/bin/env zsh

# Both `,` and `init_sync` are from my zshrc
source ~/.zshrc > /dev/null

set -e

figlet "Mounting all Systems' Drives"
[[ -e ~/network/Chris/home    ]] || sshfs Chris:/ ~/network/Chris || true
[[ -e ~/network/hpshiny/home ]] || sshfs hpshiny:/ ~/network/hpshiny || true
[[ -e ~/network/popmac/home  ]] || sshfs popmac:/ ~/network/popmac || true
[[ -e ~/network/ptah/home    ]] || sshfs ptah:/ ~/network/ptah || true
[[ -e ~/network/sia/home     ]] || sshfs sia:/ ~/network/sia || true
[[ -e ~/network/wall/home    ]] || sshfs wall:/ ~/network/wall || true
[[ -e ~/network/work/home    ]] || sshfs work:/ ~/network/work || true

figlet "Updating Init"
init_sync

# windmills
#  fix.sh

if [[ -e ~/network/ptah/home ]] ; then
		figlet "Updating ptah"
		, ptah guix pull -c 12
		, ptah guix pull -c 12 --news
		, ptah guix package -c 12 --do-not-upgrade=telegram -u
else
		figlet "ptah not mounted"
fi

# All of the nix systems
for host in sia hpshiny wall; do
		if [[ -e ~/network/$host/home ]] ; then
				figlet "Updating $host"
				, $host sudo nixos-rebuild switch --upgrade
		else
				figlet "$host not mounted"
		fi
done

# algernon
#  sudo apt update
#  #sudo apt upgrade
#  U guix pull -c 4
#  guix package -c 4 --keep-going -u && guix gc
#  # Free up space on /boot?
#  #sudo apt purge
#  #sudo apt autoremove
#  #sudo apt clean

## work msys
##  pacman -Syu

# work wsl
# sudo apt update
# sudo apt upgrade
# guix pull -c 20
# guix package -c 20 -u

# termux @ phone
#  apt update
#  apt upgrade

# Chris@something
#  # Probably just mount, sync init, updated

# Wizard @ Mainrig
#  # Check when the last update was and send a reminder
#  # I want to encourage them performing the maintenance
#  stat -c %y /var/lib/apt/periodic/update-success-stamp
#  stat -c %y /var/lib/apt/lists

# popmac
# - Seems to auto update the system and packages correctly
# - still good to check on sometimes

## For Later
## nixos channel updates
## seems to be safe upgrade ( so says https://nixos.org/manual/nixos/stable/#sec-upgrading )
## find newest number here https://channels.nixos.org/
# sudo nix-channel --add https://channels.nixos.org/nixos-25.05 nixos
# sudo nixos-rebuild switch --upgrade
