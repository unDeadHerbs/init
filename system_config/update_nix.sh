#!/usr/bin/env zsh

set -ex

# TODO: Parallel each computer?

# TODO: Test alejandra parsing first.

# In order of how hard they are to fix if it's bad.
nix_computers=("wall" "hpshiny" "pi-wall.local" "sia" "loaner" "Chris")

test_computer(){
		ssh "$1" echo || { figlet "Skip : $1" ; return 1 ;}
		figlet "$1"
		rsync -az ~/init/system_config/ "$1":/home/udh/init/system_config/
		ssh "$1" -t sudo nixos-rebuild switch --upgrade --keep-going # \; exit \$\? #||
				#ssh "$1" -t sudo nixos-rebuild switch --upgrade --option substitute false
		#ssh $1 git checkout HEAD -- /home/udh/init/system_config
		#return $?
}

#FAIL=0
if [ "$#" -ne 0 ]; then
		while [[ $# -gt 0 ]]; do
				test_computer "$1"
				#[ $? -ne 0 ] && FAIL=1
				shift
		done
else
		for comp in $nix_computers; do
				test_computer $comp
				#[ $? -ne 0 ] && FAIL=1
		done
fi
#[ "$FAIL" -eq 1 ] && exit 1
