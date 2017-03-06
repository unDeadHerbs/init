.PHONY: progams configs
all: progams configs

progams:
#not sure how to do this part yet
#emacs i3 zsh dmenu xfce4-terminal i3status feh

.PHONY: i3 emacs xinitrc zshrc fehbg screenrc tmux.conf git
configs: i3 emacs xinitrc zshrc fehbg screenrc tmux.conf git

i3:
	-mv ~/.i3/config ~/init/.i3/config.$$HOSTNAME -nv
	-rm -rf ~/.i3
	ln -sf ~/init/.i3 ~/.i3

emacs:
	mkdir -p ~/.emacs.d
	ln -sf ~/init/init.sh ~/.emacs.d/init.sh
	ln -sf ~/init/.dotemacs.org ~/.dotemacs.org

xinitrc:
	ln -sf ~/init/.xinitrc ~/.xinitrc

zshrc:
	rm -ifv ~/.zshrc
	ln -sf ~/init/.zshrc ~/.zshrc

fehbg:
	rm -ifv ~/.fehbg
	ln -sf ~/init/.fehbg ~/.fehbg

screenrc:
	rm -ifv ~/.screenrc
	ln -sf ~/init/.screenrc ~/.screenrc

tmux.conf:
	rm -ifv ~/.tmux.conf
	ln -sf ~/init/.tmuxrc ~/.tmux.conf

git:
	git config --global core.excludesfile '~/init/.gitignore'
	git config --global include.path "~/init/.gitconfig"
