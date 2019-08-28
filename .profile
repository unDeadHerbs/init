#!/bin/sh

# For compatibility with Termux
[[ "$HOST" == "" ]] && export HOST=`hostname`
[[ "$USER" == "" ]] && export USER=`whoami`

[[ -e ~/.profile.d/base ]] && source ~/.profile.d/base
[[ -e ~/.profile.d/$HOST ]] && source ~/.profile.d/$HOST
[[ -e ~/.profile.d/$USER ]] && source ~/.profile.d/$USER
