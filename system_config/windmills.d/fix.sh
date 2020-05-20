#!/bin/bash
set -e

DefaultArgs="--keep-going --verbose-conflicts"

u(){ until $@; do sleep 1; done }

# Make system consistent
emerge -qvDn @world --backtrack=30 $DefaultArgs
emerge -qvDnNU @world --backtrack=30 $DefaultArgs
emerge -qvDnNUu @world --backtrack=30 $DefaultArgs

# Get any updates
eix-sync -q

emerge -qvDnNUu @world --backtrack=30 $DefaultArgs

emerge -qvc --ask # yep, keep the ask



#emerge -NUu1D @world --backtrack=30 $DefaultArgs $@
#emerge -NUu1D @world --backtrack=30 $DefaultArgs $@
#python-updater -- $DefaultArgs $@
# --exclude libreoffice --exclude google-chrome --exclude cross-i686-pc-mingw32/gcc
perl-cleaner --reallyall -- -qv $DefaultArgs $@
# --exclude libreoffice --exclude google-chrome --exclude cross-i686-pc-mingw32/gcc
emerge @preserved-rebuild $DefaultArgs $@
revdep-rebuild -iv -- $DefaultArgs $@ # --exact seems to have been removed?

#cat /proc/cpuinfo | grep flags | uniq
# echo -n 255 > /sys/devices/platform/i8042/serio1/speed
# echo -n 255 > /sys/devices/platform/i8042/serio1/sensitivity

# cd /usr/include
# ln -s freetype2 freetype

#chsh -s $(which zsh)

#emerge -qva1 $(emerge -qvac 2>&1|grep pulle|sed -e 's/^ [*]   //' -e 's/[:[].*//' -e 's/[=><]//g' -e 's/[-][r0-9.-]*$//'|grep -v "pull"|uniq|xargs echo) --autounmask=y

mandb


##
# for later
##
# acct-group/tape: 0 none none
# acct-group/tty: 0 none none
# virtual/logger: 0-r1 none none
# virtual/shadow: 0 none none
# acct-group/disk: 0 none none
# acct-group/cdrom: 0 none none
# acct-group/video: 0 none none
# sys-devel/bin86: 0.16.21 none none
# acct-group/dialout: 0 none none
# acct-group/kmem: 0 none none
# virtual/python-funcsigs: 2-r1 none none
# acct-group/audio: 0 none none

