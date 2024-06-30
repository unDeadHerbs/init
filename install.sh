#! /usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null 2>&1 && pwd )"

toInstall=""

if type stow > /dev/null 2>&1
then
		pushd home
		stow . -v -t ~
		popd
else
		toInstall="$toInstall stow"		
fi

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
    # if on termux then just `chsh -s zsh`
else
    toInstall="$toInstall zsh"
fi

if ! [ -z "$toInstall" ]
then
    echo "Install$toInstall"
    echo "Then rerun $0"
fi
