##
# Setup environment
##
cd
alias mdr='mkdir -p'
alias l='ln -sf'
alias r='rm -rf'

##
# install missing programs
##
if uname -r|grep -i gentoo
then
   export install='emerge -qvan'
else if uname -r|grep -i debian
     then
	 export install='apt install'
     fi
fi

if type sudo|egrep -v "su( |$)"
then
    type emacs || sudo $install emacs
    type i3    || sudo $install i3
    type zsh   || sudo $install zsh
else
    if ! { type emacs && type i3 && type zsh }
    then
	su -c '$install emacs i3 zsh'
    fi
fi

##
# remove links to configs
##

# remove any links to init file that currently exist
# the next line has a bug for any files with the sym " -> " in their name
# there should' be any of those because that's dumb
ls -la|grep " [-][>] "|sed 's/[-lrwx]* *[0-9] *\w* *\w* *[0-9]* *\w* *[0-9]* *[0-9]*:*[0-9]* *//'|grep "$(pwd)/init" 
# this is such that on systems that are being upgreaded this will act the same as a fresh install


##
# Existing configs
##
# if it needs backing up or deleting, do so
##
if [ -e "~/.i3/config" ]
then
    mv ~/.i3/config ~/init/.i3/config.$(hostname)
fi
r ~/.i3 ~/.fehbg ~/.dotemacs.org ~/.screenrc


##
# set up space for configs
##
mdr .config
mdr .emacs.d

##
# set up the config links
##
l ~/init/.i3 ~/.i3
if [ -e "~/.i3/config.$(hostname)" ]
then
    l ~/.i3/config.$(hostname) ~/.i3/config
else
    l ~/.i3/config.base ~/.i3/config
fi
cat ~/.i3/status.base > ~/.i3status.conf
cat ~/.i3/status.$(hostname) >> ~/.i3status.conf

l ~/init/.xinitrc ~/.xinitrc

for zshrc in $(ls .zshrc*)
do
		l ~/init/$zshrc ~/$zshrc
done

l ~/init/.fehbg ~/.fehbg
mdr ~/.config/xfce4/terminal
cp ~/init/xfce4/terminal/terminalrc ~/.config/xfce4/terminal
l ~/init/.dotemacs.org ~/.dotemacs.org
l ~/init/init.el ~/.emacs.d/init.el
l ~/init/.screenrc ~/.screenrc

##
# Setup system settings
##
[[ $SHELL = "$(which zsh)" ]] || type zsh && chsh -s $(which zsh)
