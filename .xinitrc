#set background
sleep 2  && bash ~/.fehbg &
sleep 10 && bash ~/.fehbg & # again after any monitor layout changes

#link the config from their bases
if [ -e "$HOME/.i3/config.$(hostname)" ]
then
    rm ~/.i3/config
    ln -sf ~/.i3/config.$(hostname) ~/.i3/config
else
    rm ~/.i3/config
    ln -sf ~/.i3/config.base ~/.i3/config
fi
cat ~/.i3/status.base > ~/.i3status.conf
cat ~/.i3/status.$(hostname) >> ~/.i3status.conf

#export laptopip=kitchensink.local
#if hostname|grep "uDH"|grep -v "uDH-x201"
#then
#    { sleep 3 && synergyc $laptopip ; } &
#fi

if [ -e "$HOME/.xinitrc.d/$(hostname)" ]
then
    source "$HOME/.xinitrc.d/$(hostname)"
fi

exec i3
