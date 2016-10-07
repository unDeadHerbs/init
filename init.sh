cd
alias mdr='mkdir -p'
# install emacs
# install i3
# install zsh
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
[[ $SHELL = "/bin/zsh" ]] || chsh -s $(which zsh)
