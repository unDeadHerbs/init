#!/usr/bin/env zsh

set -e

# TODO: parallel each computer

# TODO: Test alejandra parsing first.

# In order of how hard they are to fix if it's bad.
nix_computers=("wall" "hpshiny" "pi-wall.local" "sia" "loaner" "Chris")

test_computer(){
		ssh "$1" echo || { figlet "Skip : $1" ; return ;}
		figlet "$1"
		rsync -az ~/init/system_config/ "$1":/home/udh/init/system_config/
		ssh "$1" -t sudo nixos-rebuild switch --show-trace
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
fi
