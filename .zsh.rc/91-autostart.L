#! /bin/zsh
[[ $(tty) = "/dev/tty1" ]] && { running X || exec startx }
