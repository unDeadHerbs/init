#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null 2>&1 && pwd )"

#################
# link dotfiles #
#################

backup_increment(){
    # USAGE: backup_increment file
    # Creates a .bak file for the file also backs up any backup that
    # would be overwritten
    [[ -e $1.bak ]] && backup_increment "$1.bak"
    mv "$1" "$1.bak"
}

backup_then_link(){
    # USAGE: backup_then_link source dest
    # creates a backup of the destination if needed then links the
    # source to the destination

    if [[ -e "$2" ]]
    then
	if [[ -L "$2" ]]
	then
	    rm "$2" # it was a link
	elif diff -qw "$1" "$2" | grep "." > /dev/null
	then
	    # same content
	    # We've already checked that $2 isn't a link and rm won't
	    # follow sub simlinks. Please don't hardlink things,
	    # particularly in common locations.
	    rm -rf "$2"
	else
	    backup_increment "$2"
	fi
    fi
    ln -sf "$1" "$2"
}

#for file in $( { cd $DIR ; ls -d .* } | grep -v "[#~]" | grep -v "^.git$" )
{ cd $DIR ; ls -d .* ; } |
    grep -v "[#~]" | # ignore temp files
    grep -v '^[.]git$' | # ignore the fact that this is a git repo
    egrep -v '^[.]+$' | # ignore . and ..
    while read -r file
    do
	backup_then_link "$DIR/$file" "$HOME/$file"
    done

# We don't want to import the .emacs.d folder into here so that get's
# linked seperately.
mkdir -p "$HOME/.emacs.d"
backup_then_link "$DIR/init.el" "$HOME/.emacs.d/init.el"

# We don't want the whole .config in this repo so link the important
# file.
mkdir -p "$HOME/.config/xfce4/terminal"
backup_then_link "$DIR/terminalrc" "$HOME/.config/xfce4/terminal/terminalrc"
# TODO: Move `mkdir -p` into `backup_then_link` and add a recursive
#       option so that structures can be linked.

# add local bin to use bin
mkdir -p "$HOME/bin"
backup_then_link "$DIR/bin/" "$HOME/bin/bin"

###################################
# check for reqs and setup things #
###################################

toInstall=""

if type git > /dev/null 2>&1
then
    git config --global include.path "$DIR/gitconfig"
    git config --global core.excludesFile "$DIR/gitignore"
    [[ "$(git config --global user.signingkey)" != "" ]] &&
	git config --global commit.gpgsign true
    git config --global init.templatedir "$DIR/git_templates"
else
    toInstall="$toInstall git"
fi

if type zsh > /dev/null 2>&1
then
    [[ "$SHELL" = "$(which zsh)" ]] || chsh -s $(which zsh)
else
    toInstall="$toInstall zsh"
fi

if ! [ -z "$toInstall" ]
then
    echo "Install$toInstall"
    echo "Then rerun $0"
fi
