##
# Setup environment
##
cd
alias mdr='mkdir -p'
alias l='ln -sf'
alias r='rm -rf'
alias c='cp'

##
# install missing programs
##
programs="emacs i3 zsh dmenu xfce4-terminal i3status"

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
		for prog in "$programs"
		do
				type $prog || sudo $install $prog
		done
else
		for prog in "$programs"
		do
				if ! type $prog
				then
						su -c '$install $programs'
				fi
		done
fi

##
# Remove Links to Configs
##
# So that they don't get backed up or can be replaced.
##

# remove any links to init file that currently exist
# the next line has a bug for any files with the sym " -> " in their name
# there should' be any of those because that's dumb
ls -la|grep " [-][>] "|sed 's/[-lrwx]* *[0-9] *\w* *\w* *[0-9]* *\w* *[0-9]* *[0-9]*:*[0-9]* *//'|grep "$(pwd)/init" 
# this is such that on systems that are being upgreaded this will act the same as a fresh install


##
# Existing Configs
##
# If a config needs backing up or deleting, do so.
##
if [ -e "~/.i3/config" ]
then
    mv ~/.i3/config ~/init/.i3/config.$(hostname)
fi
r ~/.i3 ~/.fehbg ~/.dotemacs.org ~/.screenrc ~/.config/xfce4/terminal


##
# Set Up Space for the Configs
##
mdr ~/.config/xfce4/terminal
mdr .config
mdr .emacs.d


##
# Set Up the Config Links
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
l ~/init/.zshrc ~/.zshrc
l ~/init/.fehbg ~/.fehbg
l ~/init/.dotemacs.org ~/.dotemacs.org
l ~/init/init.el ~/.emacs.d/init.el
l ~/init/.screenrc ~/.screenrc
c ~/init/xfce4/terminal/terminalrc ~/.config/xfce4/terminal

##
# Setup system settings
##
[[ $SHELL = "$(which zsh)" ]] || { type zsh && chsh -s $(which zsh) }
