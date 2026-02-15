#!/usr/bin/env bash
#
# First version largely taken from 0atman

# A rebuild script that commits on a successful build
set -e

if ! uname -a | grep NixOS > /dev/null ; then
		echo "This isn't a NixOS system?"
		exit 1
fi

# TODO: better network control
# 1. Use the script location as a start
# 2. df -P .|awk 'NR==2 {print $1}' will say where the mountpoint comes from
# 3. If it has a ":" in it, then that's the remote host we should use
#    - check it's hostname
#    - send the rebuild request to it over ssh

# TODO: If non-existent, make a migrate script for the base config
pushd ~/init/system_config/${HOSTNAME}
$EDITOR ${HOSTNAME}.nix

# Early return if no changes were detected
if git diff --quiet '*.nix' ;then
		echo "No changes detected, exiting."
		popd
		exit 0
fi

# Auto format
alejandra . > /dev/null \
			|| ( alejandra . ;echo "formatting failed!" && exit 1 )

# Shows your changes so that errors are debug-able and the scroll back is nice
git diff -U0 '*.nix'

echo "NixOS Rebuilding..."
mkdir -p ~/tmp

# Rebuild, log last trace back, output only errors
sudo nixos-rebuild switch --upgrade &> ~/tmp/nixos-switch.log || ( cat ~/tmp/nixos-switch.log | grep -Ei --color "warn|error|failed" -C2 && popd && exit 1 )
cat ~/tmp/nixos-switch.log | grep -Ei --color "warn|error|failed" || true

# Commit on success
current=$(nixos-rebuild list-generations | grep current || nixos-rebuild list-generations | grep True\$)
git add '*.nix'
git commit -m "${HOSTNAME}: $current"

popd
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
