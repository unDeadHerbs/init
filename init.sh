cd
alias mdr='mkdir -p'

if uname -r|grep -i gentoo
then
   alias install='emerge -qvan'
else if uname -r|grep -i debian
     then
	 alias install='apt install'
fi   fi

if type sudo
then
    type emacs || sudo install emacs
    type i3    || sudo install i3
    type zsh   || sudo install zsh
else
    if { type emacs && type i3 && type zsh }
    then
    else
	su -c 'install emacs i3 zsh'
    fi
fi


mkdir -p .config
mkdir -p .emacs.d
rm -rf ~/.i3
ln -sf ~/init/.i3 ~/.i3
ln -sf ~/init/.xinitrc ~/.xinitrc
ln -sf ~/init/.zshrc ~/.zshrc
ln -sf ~/init/.fehbg ~/.fehbg
mdr ~/.config/xfce4/terminal
cp ~/init/xfce4/terminal/terminalrc ~/.config/xfce4/terminal
ln -sf ~/init/.dotemacs.org ~/.dotemacs.org
ln -sf ~/init/init.el ~/.emacs.d/init.el
ln -sf ~/init/.screenrc ~/.screenrc
[[ $SHELL = "$(which zsh)" ]] || type zsh && chsh -s $(which zsh)
