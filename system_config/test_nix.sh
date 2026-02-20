#!/usr/bin/env zsh

set -e

# TODO: Test alejandra parsing first.

# In order of how fast/easily they respond
nix_computers=("loaner" "hpshiny" "sia" "Chris") # "wall"

test_computer(){
		ssh "$1" echo || { figlet "Skipping : $1" ; continue;}
		figlet "Trying : $1"
		# TODO: maybe rsync?
		scp -qr ~/init/system_config/* "$1":/home/udh/init/system_config
		ssh "$1" -t sudo nixos-rebuild test
		#ssh $1 git checkout HEAD -- /home/udh/init/system_config
}

if [ "$#" -ne 0 ]; then
		while [[ $# -gt 0 ]]; do
				test_computer "$1"
				shift
		done
else
		for comp in $nix_computers; do
				test_computer $comp
		done

		(
				cd ~/init/system_config/
				git diff .
		)
fi
