cd
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
ln -sf ~/init/xfce4 ~/.config/xfce4
ln -sf ~/init/.dotemacs.org ~/.dotemacs.org
ln -sf ~/init/init.el ~/.emacs.d/init.el
ln -sf ~/init/.screenrc ~/.screenrc
chsh -s $(which zsh)
