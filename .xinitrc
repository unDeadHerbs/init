#make sure init file is updated
#{ cd ~/init ; git pull } &

#source ~/.zshrc

#set background
sleep 2  && bash ~/.fehbg &
sleep 10 && bash ~/.fehbg &

#link the config from their bases
if [ -e "~/.i3/config.$(hostname)" ]
then
    ln -sf ~/.i3/config.$(hostname) ~/.i3/config
else
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

export laptopip=10.0.128.106

# computer spesific setup
if [ $(hostname) = "uDH-tower" ]
then
    # position screens
    sleep   1 && xrandr --output DVI-0 --rotate right

    sleep   1 && synergyc $laptopip &
    autogaussport &
    #sleep   1 && i3-msg 'workspace  1; exec xfce4-terminal --command=pianobar' &
    #sleep  15 && i3-msg 'workspace  2; exec thunderbird' &
    #sleep  30 && i3-msg 'workspace 11; exec skype' &
    #sleep  40 && i3-msg 'workspace 11; exec python2.7 skypestart.py ' &
    #sleep  60 && i3-msg 'workspace  3; exec ~/steam/steam/steam.sh' &
    #sleep 150 && i3-msg 'workspace  4; exec firefox' &
    #sleep 200 && i3-msg 'workspace 12; exec google-chrome-stable' &
    ##sleep 400 && i3-msg 'workspace  1' &
    sleep  80 && widget &

    sleep  25 && i3-msg 'workspace  2; exec thunderbird' &
    #sleep 30 && i3-msg 'workspace  3; exec skype' &
    sleep  5 && i3-msg 'workspace 11; exec xfce4-terminal --command=alsamixer' &
    sleep  7 && i3-msg 'exec xfce-terminal --command=pianobar' &
    #splitv
    sleep 62 && i3-msg 'workspace 12; exec kvirc4 --nosplash' &
    sleep 64 && i3-msg 'layout tabbed' &
    sleep 70 && i3-msg 'workspace 11' &
    #sleep 60 && i3-msg 'workspace 12; exec firefox' &
    #sleep 68 && i3-msg 'layout tabbed' &
    sleep 75 && i3-msg 'workspace 11; exec xfce4-terminal --command="zsh -c autogaussport"' &
    sleep 80 && i3-msg 'workspace  3; exec google-chrome-stable' &
    sleep 100 && i3-msg 'layout tabbed' &
    sleep 120 && i3-msg 'workspace  2' &
fi

if [ $(hostname) = 'uDH-x201' ]
then
    sleep  1 && qsynergy &
    #sleep 20 && i3-msg 'workspace 14; layout tabbed' &
    #sleep 23 && i3-msg 'exec xfce-terminal; split h; layout tabbed' &
    #sleep 25 && i3-msg 'focus parent; exec xfce-terminal; layout tabbed; focus parent; exec xfce-terminal --command=skype; layout tabbed' &
    #sleep 40 && i3-msg 'focus parent; exec xfce-terminal; split h; exec xfce-terminal; split v; exec xfce-terminal; exec xfce-terminal' &
    #sleep 42 && i3-msg 'focus parent; move left' &
    xrandr --output VGA1 --left-of LVDS1
fi

if [ $(hostname) = 'uDH-deb' ]
then
    sleep   1 && xrandr --output VGA-1 --rotate left
    sleep   1 && synergyc $laptopip &
fi

if [xrandr --output VGA1 $(hostname) = 'Kitty' ]
then
    sleep 1 &
fi

if [ $(hostname) = 'uDH-Bot' ]
then
    sleep   1 && synergyc $laptopip &
fi

if [ $(hostname) = 'L' ]
then
    sleep 1 && synergyc 192.168.1.106 &
fi
    

#emacs --daemon
exec i3
