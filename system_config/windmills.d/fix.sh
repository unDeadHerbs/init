#!/bin/bash
set -e

DefaultArgs="-qv --keep-going --verbose-conflicts --autounmask"
exclude_known_sad="--exclude libpvx"

# Make system consistent
emerge -Dn @world --backtrack=30 $DefaultArgs $exclude_known_sad
emerge -DnNU @world --backtrack=30 $DefaultArgs $exclude_known_sad
emerge -DnNUu @world --backtrack=30 $DefaultArgs $exclude_known_sad

# Get any updates
eix-sync -q

# Check the news before installing updates
eselect news list
echo
echo "Cancle if there is any important news"
echo "Otherwise, press enter to contune"
read

emerge -DnNUu @world --backtrack=30 $DefaultArgs $exclude_known_sad
# if manually doing this, also try the "sad" things to see if any of them are fixed or fixable errors

emerge -qvc --ask --exclude gentoo-sources # keep the ask

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

#emerge -qva1 $(emerge -qvac 2>&1|grep pulle|sed -e 's/^ [*]   //' -e 's/[:[].*//' -e 's/[=><]//g' -e 's/[-][r0-9.-]*$//'|grep -v "pull"|uniq|xargs echo) --autounmask=y

mandb
