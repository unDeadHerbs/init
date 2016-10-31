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
programs="emacs i3 zsh dmenu xfce4-terminal i3status feh"

if uname -r|grep -i gentoo
then
	 export install='emerge -qvan'
else
		if uname -r|grep -i debian
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

# This section has a bug for some files with the sym " -> " in their name
# There should' be any of those because that's dumb so I have not fixed it
alias escpath="sed 's/\\//\\\\&/g'"
alias lv="'ls' -la|sed 's/[-dlrwx?]* *[0-9?]* *\w* *\w* *[0-9?]* *\w* *[0-9?]* *[0-9?]*:*[0-9]* *[?]* *//'"
alias rml='lv|grep " [-][>] "|grep "$HOME/init"|sed "s/ [-][>] .*//"|sed "s/./rm -f $(pwd|escpath)\/&/"'
(cd ~;rml)
(cd ~/.config;rml)
# this will just echo the commands as i am not yet on a testing system

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

files=(".xinitrc" ".zshrc" ".fehbg" ".dotemacs" ".screenrc" ".emacs.d/init.el")
for file in $file
do
		echo l ~/init/$file ~/$file
done
c ~/init/xfce4/terminal/terminalrc ~/.config/xfce4/terminal

##
# Setup system settings
##
echo $SHELL|grep zsh || { type zsh && chsh -s $(which zsh) }

