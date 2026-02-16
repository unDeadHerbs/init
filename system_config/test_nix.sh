#!/usr/bin/env zsh

set -e

# TODO: Test alejandra parsing first.

# In order of how fast/easily they respond
nix_computers=("wall" "hpshiny" "sia" "Chris")

for comp in $nix_computers; do
		ssh $comp echo || { figlet "Skipping : $comp" ; continue;}
		figlet "Trying : $comp"
		# TODO: maybe rsync?
		scp -qr ~/init/system_config/. $comp:/home/udh/init/system_config
		ssh $comp -t sudo nixos-rebuild test
done

(
		cd ~/init/system_config/
		git diff .
)
