cd
alias mdr='mkdir -p'
which sudo || alias sudo='su -c'

# remove any links to init file that currently exist
# the next line has a bug for any files with the sym " -> " in their name
# there should' be any of those because that's dumb
ls -la|grep " [-][>] "|sed 's/[-lrwx]* *[0-9] *\w* *\w* *[0-9]* *\w* *[0-9]* *[0-9]*:*[0-9]* *//'|grep "$(pwd)/init" 
# this is such that on systems that are being upgreaded this will act the same as a fresh install

if uname -r|grep -i gentoo
then
   export install='emerge -qvan'
else if uname -r|grep -i debian
     then
	 export install='apt install'
fi   fi

if type sudo
then
    type emacs || sudo $install emacs
    type i3    || sudo $install i3
    type zsh   || sudo $install zsh
else
    if ! type emacs && type i3 && type zsh
    then
	su -c '$install emacs i3 zsh'
    fi
fi

mkdir -p .config
mkdir -p .emacs.d

# if the user has an existing config back it up
if [-e "~/.i3/config" ]
then
    mv ~/.i3/config ~/init/.i3/config.$(hostname)
fi
rm -rf ~/.i3
ln -sf ~/init/.i3 ~/.i3
# set up the config links
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

ln -sf ~/init/.xinitrc ~/.xinitrc
ln -sf ~/init/.zshrc ~/.zshrc
ln -sf ~/init/.fehbg ~/.fehbg
mdr ~/.config/xfce4/terminal
cp ~/init/xfce4/terminal/terminalrc ~/.config/xfce4/terminal
ln -sf ~/init/.dotemacs.org ~/.dotemacs.org
ln -sf ~/init/init.el ~/.emacs.d/init.el
ln -sf ~/init/.screenrc ~/.screenrc
[[ $SHELL = "$(which zsh)" ]] || type zsh && chsh -s $(which zsh)
