#make sure init file is updated
#{ cd ~/init ; git pull } &

#source ~/.zshrc

#set background
sleep 2  && bash ~/.fehbg &
sleep 10 && bash ~/.fehbg &

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
#if [ -e "~/.i3/status.$(hostname)" ]
#then
#    ln -sf ~/.i3/status.$(hostname) ~/.i3status.conf
#else
#    ln -sf ~/.i3/status.base ~/.i3status.conf
#fi

export laptopip=uDH-x201.local
if hostname|grep "uDH"|grep -v "uDH-x201"
then
    { sleep 3 && synergyc $laptopip ; } &
fi

if [ $(hostname) = "windmills" ]
then
    ##
    # Position screens
    ##
    
    sleep   1 && xrandr --output DisplayPort-1 --rotate left &
    sleep   1 && xrandr --output DVI-0 --rotate left &

    ##
    # Move Desktops to the correct screens
    ##

    sleep   2 && i3-msg 'workspace  11' &
    sleep   3 && i3-msg 'workspace   1' &

    ##
    # Programs
    ##
    
    #sleep  25 && i3-msg 'workspace  2; exec thunderbird' &
    
    #sleep  40 && i3-msg 'workspace 11; exec python2.7 skypestart.py ' &
    #sleep  60 && i3-msg 'workspace  3; exec ~/steam/steam/steam.sh' &
    #sleep  30 && i3-msg 'workspace  3; exec skype' &

    #sleep   5 && i3-msg 'workspace 11; exec xfce4-terminal --command=alsamixer' &
    #sleep   7 && i3-msg 'exec xfce-terminal --command=pianobar' &

    #sleep  62 && i3-msg 'workspace 12; exec kvirc4 --nosplash' &
    #sleep  64 && i3-msg 'layout tabbed' &

    #sleep  60 && i3-msg 'workspace 12; exec firefox' &
    #sleep  68 && i3-msg 'layout tabbed' &

    #sleep  80 && i3-msg 'workspace  3; exec google-chrome-stable' &
    #wait for the tabs to load
    sleep 100 && i3-msg 'layout tabbed' &

    ##
    # Move to main workspace
    ##

    #sleep 120 && i3-msg 'workspace  2' &
fi

if [ $(hostname) = 'uDH-x201' ]
then
    ##
    # Start Daemons
    ##
    sleep  1 && qsynergy &

    ##
    # start default workspace
    ##
    sleep  1 && i3-msg "workspace  1; exec xfce4-terminal" &
    sleep  2 && i3-msg "split v" &
    #sleep  3 && i3-msg "exec xfce4-terminal -e 'pianobar'" &
    #sleep  4 && i3-msg "exec xfce4-terminal -e 'alsamixer'" &
    sleep  5 && i3-msg "exec xfce4-terminal -e 'zsh -ic \"e todo\"'" &
    sleep  6 && i3-msg "move right" &
    sleep  7 && i3-msg "workspace  0; exec xfce4-terminal -e 'zsh -ic \"su\"'" &
    sleep  8 && i3-msg "exec xfce4-terminal -e 'zsh -ic \"rhtop\"'" &
    sleep  9 && i3-msg "move up" &
    sleep 10 && i3-msg "resize shrink height 30 px or 30 ppt" &
    sleep 11 && i3-msg "workspace 1" &
    #sleep 20 && i3-msg 'workspace 14; layout tabbed' &
    #sleep 23 && i3-msg 'exec xfce-terminal; split h; layout tabbed' &
    #sleep 25 && i3-msg 'focus parent; exec xfce-terminal; layout tabbed; focus parent; exec xfce-terminal --command=skype; layout tabbed' &
    #sleep 40 && i3-msg 'focus parent; exec xfce-terminal; split h; exec xfce-terminal; split v; exec xfce-terminal; exec xfce-terminal' &
    #sleep 42 && i3-msg 'focus parent; move left' &

    ##
    # Setttup screens
    ##
    #if exists second screen then
    #   xrandr --output VGA1 --left-of LVDS1
    #fi
fi

if [ $(hostname) = 'uDH-deb' ]
then
    sleep   1 && xrandr --output VGA-1 --rotate left
fi

if [ $(hostname) = 'uDH-Bot' ]
then
    echo #nothing
fi

if [ $(hostname) = 'Kitty' ]
then
    sleep 1 && qsynergy &
    sleep 10 && i3-msg "workspace  1; exec xfce4-terminal -e 'zsh -ic autogaussport'" &
fi

exec i3
