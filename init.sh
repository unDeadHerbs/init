#!/bin/bash

##
echo "Setup environment install"
##
set -e
cd
mdr='mkdir -p'
l='ln -sf'
r='rm -rf'
c='cp'

##
echo "Installing missing programs"
##

function install_command(){
		if [ `uname -r|grep -i gentoo` ]; then
				echo 'emerge -qvan'
		elif [ `uname -r|grep -i debian` ]; then
				echo 'apt install'
		else
				exit 1
		fi
}

function needed_programs(){
		for prog in "emacs" "i3" "zsh" "dmenu" "xfce4-terminal" "i3status" "feh"
		do
				type $prog 1>/dev/null 2>/dev/null ||
						echo $prog
		done|
		# one line them
		xargs echo
}

function install_needed_programs(){
		if [ `needed_programs` ]; then
				echo "some progams are needed"
				#check that my bad sudo alias isn't running
				if type sudo|egrep -v "su( |$)" 2>/dev/null ; then
						{
								install_command
								needed_programs
						}|xargs sudo
				else
						su -c "`install_command` `needed_programs`"
				fi
		fi
}

install_needed_programs

##
echo "Removing Sym-Links to Configs"
##
# So that they don't get backed up and can be replaced with the new ones.
##

# TODO: This section has a bug for some files with the sym " -> " in their name.
#       There should' be any of those because that's dumb so I have not fixed it.
#       There is probably a way to list only links in find.
escpath="sed 's/\//\\&/g'"
function list_something(){
		'ls' -la|sed 's/[-dlrwx?]* *[0-9?]* *\w* *\w* *[0-9?]* *\w* *[0-9?]* *[0-9?]*:*[0-9]* *[?]* *//'
		}
function list_links(){
		list_something|
				grep " [-][>] "|
				grep "$HOME/init"
}
function rm_links(){
		list_links|
				sed "s/ [-][>] .*//"|
				sed "s/./rm -f $(pwd|sed 's/\//\\&/g')\/&/"|
				sh
}
cd ~
rm_links
cd ~/.config
rm_links
cd

##
echo "Saving Existing Configs"
##
# If a config needs backing up or deleting, do so.
##
if [ -e "~/.i3/config" ]
then
		mv ~/.i3/config ~/init/.i3/config.$(hostname)
fi
$r ~/.i3 ~/.fehbg ~/.dotemacs.org ~/.screenrc ~/.config/xfce4/terminal

##
echo "Createing Folders for the Configs"
##
$mdr ~/.config/xfce4/terminal
$mdr .config
$mdr .emacs.d

##
echo "Creating Links to Config files"
##
$l ~/init/.i3 ~/.i3
if [ -e "~/.i3/config.$(hostname)" ]
then
		$l ~/.i3/config.$(hostname) ~/.i3/config
else
		$l ~/.i3/config.base ~/.i3/config
fi
cat ~/.i3/status.base > ~/.i3status.conf
cat ~/.i3/status.$(hostname) >> ~/.i3status.conf

files=(".xinitrc" ".zshrc" ".fehbg" ".dotemacs" ".screenrc" ".emacs.d/init.el")
for file in $file
do
		echo $l ~/init/$file ~/$file
done
$c ~/init/xfce4/terminal/terminalrc ~/.config/xfce4/terminal

##
echo "Seting up user settings"
##
echo $SHELL|grep zsh || { type zsh && chsh -s $(which zsh) }
#git config --global core.excludesfile '~/.gitignore'
#git config --global include.path "~/init/.gitconfig"
