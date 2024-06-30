#!/usr/bin/env bash
#
# First version largely taken from 0atman

# A rebuild script that commits on a successful build
set -e

pushd ~/init/system_config/${HOSTNAME}
$EDITOR ${HOSTNAME}.nix

# Early return if no changes were detected
if git diff --quiet '*.nix' ;then
		echo "No changes detected, exiting."
		popd
		exit 0
fi

# Auto format
alejandra . & > /dev/null \
			|| ( alejandra . ;echo "formatting failed!" && exit 1 )

# Shows your changes so that errors are debug-able and the scroll back is nice
git diff -U0 '*.nix'

echo "NixOS Rebuilding..."

# Rebuild, log last trace back, output only errors
sudo nixos-rebuild switch &> nixos-switch.log || ( cat nixos-switch.log | grep --color error && popd && exit 1 )

# Commit on success
current=$(nixos-rebuild list-generations | grep current)
git add '*.nix'
git commit -m "$current"

popd
notify-send-e "NixOS Rebuilt OK!" --icon=software-update-available
