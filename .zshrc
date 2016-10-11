##
# The following lines were added by compinstall
##

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list '' '' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=long-list select=1
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/udh/.zshrc'
#zstyle ':compleation:*' path-completion false
zstyle ':completion:*' accept-exact-dirs true

autoload -Uz compinit
compinit
# End of lines added by compinstall

##
# Lines configured by zsh-newuser-install
##
HISTFILE=~/.histfile
pHISTSIZE=1000
SAVEHIST=10000000000
setopt appendhistory
unsetopt notify
bindkey -e
# End of lines configured by zsh-newuser-install

##
# Lines from Arch Wiki
##
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

##
# page up through history
##
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"    history-beginning-search-backward
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}"  history-beginning-search-forward

##
# prompt colouring
##
autoload -U colors
colors
PROMPT="%{$fg[green]%}%n%{$fg_no_bold[cyan]%}@%{$fg[green]%}%m %{$fg_no_bold[cyan]%}%~ %#%{$reset_color%} "
RPROMPT="[%{$fg_no_bold[yellow]%}%?%{$reset_color%}] %{$fg_no_bold[cyan]%}20%DT%T%{$reset_color%}"

# Fish-Like syntax hilighting
# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

##
# Make sure that the folder and commands lists are up to date (but a little slower)
##
setopt nohashdirs
setopt nohashcmds
# End of lines from Arch Wiki

# http://blog.pengyifan.com/how-to-set-terminal-title-dynamically-to-the-current-working-directory/

#case $TERM in
#  xterm*)
#    precmd () {print -Pn "\e]0;%~\a"}
#    ;;
#esac

##
# so that M-b and M-f work properly
##
export WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'

##
# so that tramp works
##

if [[ "$TERM" == "dumb" ]]
then
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    unfunction precmd
    unfunction preexec
    PS1='$ '
fi

##
# Alias section by uDH
##

# used for this file and readability
alias exists='type'
alias running='pidof'
alias os="uname -r|sed 's/^.*[-]//'"
alias murrays="hostname|grep uDH"

# lines above here should be changed with caution as they will cause randome jumps when the code moves in the file
# assuming that zsh dosen't copy it's config out of location to prevent that (like org-dotemacs does)
# refresh init file on systems
[[ $(tty) = "/dev/tty1" ]] && ( cd init ; git pull )
[[ $(tty) = "/dev/tty2" ]] && ( cd init ; git pull )

# Add aliases for programs that are installed on single machines
if [ $(hostname) = 'uDH-x201' ]
then
    alias sublime="~/Sublime_Text_3/sublime_text"
    alias sublime2="~/Sublime_Text_2/sublime_text"
    alias steam="steam/steam/steam.sh"
    alias torchlite="apulse /usr/local/games/Torchlight/Torchlight.bin.x86"
fi

# Add default options to programs
# some of these probably don't need checking, but for the sake of autocompleations being correct i will anyway
exists sdate      && alias sdate="sdate|sed 's/.*\([0-9][0-9][0-9][0-9]\) .*/\1/'"
exists ls         && alias ls="ls --color"
exists ssh        && alias ssh='ssh -o ConnectionAttempts=4 -Y'
#-o ConnectTimeout=1'
exists nano       && alias nano="nano -w"
exists wget       && alias wget='wget -c -t 5 --waitretry 60'
exists ed         && alias ed='ed -p "*"'
exists sl         && alias sl='sl -l'
exists sshfs      && alias sshfs="sshfs -C -o reconnect"
exists mc         && alias mc="mc -a"
exists emacs      && alias emacs='emacs -nw '
exists emacs      && alias emacsclient='emacsclient -a "" -tc '
exists youtube-dl && alias youtube-dl='youtube-dl -i -c'
exists autossh    && alias autossh='autossh -M 0'
exists mosh       || alias mosh='ssh'
exists pianobar   && alias pianobar='pianobar 2> /dev/null'
exists find       && alias finds='find 2>/dev/null'

# Create aliases for programs that  need to be run as root
##todo: have that check if in sudoers file
exists sudo || alias sudo='su -c'
alias htop="sudo 'screen htop'"
#alias s2ram="sudo s2ram"
alias s2ram="sudo 'swapon /dev/sda3 && s2ram && swapoff /dev/sda3'"
alias reboot="sudo 'reboot'"
alias poweroff="sudo 'poweroff'"
alias shutdown='poweroff'
alias dhcpcd-reset="sudo 'dhcpcd && dhcpcd -x && dhcpcd && dhcpcd -x && dhcpcd'"
exists wicd-curses && alias wicd-restart="sudo 'rc-config restart wicd'"

# Export general values that other programs rely on settings
[[ $(os) = "gentoo" ]] && export EIX_LIMIT=0
export TERMINAL="xfce4-terminal"
exists ed    && export EXPORT='ed'
exists vim   && export EDITOR='vim'
exists vi    && export EXPORT='vi'
exists emacs && export EDITOR='emacs -nw'
alias e='$(echo $EDITOR)'
if exists google-chrome-stable
then
    export BROWSER="google-chrome-stable"
else
    exists firefox && export BROWSER="firefox"
fi

#
exists i3lock && { exists s2ram && alias slep="sudo s2ram && i3lock" || alias slep="i3lock" };

#IP addresses
if [ $(hostname) = 'uDH-x201' ]
then
    export toweradd='10.0.128.107'
    export debadd='10.0.0.53'
    export botadd='10.0.0.54'
    #export mcadd='107.170.32.101'
    #export botadd='137.104.208.79'
    #export gaussadd='107.170.32.101'
fi
export gaussadd='bk.gg'
export mcadd='${gaussadd}'
export widgetadd='cygwin_ssh@home.widget.dj'
export widgetport='9001'

# ssh
#alias sshhome="ssh root@udh.no-ip.org -p 25567"
#alias sshtower='ssh 10.20.39.13'
if [ $(hostname) = 'uDH-x201' ]
then
    alias sshtower='mosh ${toweradd}'
fi
alias sshmc='ssh minecraft@${mcadd}'
alias sshdb='ssh ${gaussadd}'
alias sshgauss='ssh ${gaussadd}'
alias sshwidget='ssh ${widgetadd} -p ${widgetport}'
alias sshratcht='ssh undeadherbs@ratchtnet.cf'
#alias sshmfs='ssh murray.fordyce.sexy'

# sshfs
if exists sshfs
then
    alias widget='sshfs ${widgetadd}:/cygdrive/ ~/widget/ -p ${widgetport}'
    #alias tower='sshfs root@udh.no-ip.org:/ ~/tower/ -p 25567'
    #alias tower='sshfs udh@172.26.201.64:/ ~/tower/'
    #alias tower='sshfs udh@10.20.39.13:/ ~/tower/'
    [[ $(hostname) = 'uDH-x201' ]] && alias tower='sshfs udh@${toweradd}:/ ~/tower/'
    alias drinkboot='sshfs udh@${gaussadd}:/ ~/drinkboot/'
fi
if murrays
then
    alias gaussproxy='autossh -M 0 ${gaussadd} -D 1414'
    alias gaussport='ssh -R 2200:localhost:22 ${gaussadd}'
    alias autogaussport='while true; do; gaussport; done'
fi

# programs on other systems
if [ $(hostname) = 'uDH-x201' ]
then
   alias thundirbird="ssh -Y ${toweradd} -t 'thunderbird'"
fi

# pipe-able things
if murrays
then
    alias rot13="tr 'A-Za-z0-9' 'N-ZA-Mn-za-m'5-90-4"
    alias sedesc="sed 's/[] ()'\''\\\\[&;]/\\\\&/g'"
    alias sedquote="sed 's/^./\"&/'|sed 's/.$/&\"/'"
    alias sedtack="sed 's/[-]/\\-/g'"
    alias toascii="perl -ne 'chomp if eof;for(unpack(\"C*\")){print\"\$_ \"}print\"\\n\"if eof'"
    alias spaceseperate="sed 's/./& /g'"
    alias unspaceseperate="sed 's/\(.\) /\1/g'"
    alias firstline="perl -pe '<>'"
    [[ $(hostname) = 'uDH-x201' ]] && alias delta="~/ai/cpp/stream/delta"
    exists espeak && alias toipa='espeak --stdin -q --ipa'
    alias buffer="sed''|perl -ne '\$a[\$n++]=\$_;if(eof){for(@a){print}}'|sed''"
    #alias reverse="perl -ne 'something fancy'"
fi

# renaming things
murrays && alias nano='echo use $EDITOR for editing file '
if exists emacs
then
    alias emcl='emacsclient'
    if echo $EDITOR|grep emacs
    then
	if ! ps -ef|grep emacs|grep "server-start"
	then
	    emacs --eval "(if (not (server-running-p)) (server-start))" --daemon &
	fi
	alias emacs='emacsclient'
	export EDITOR='emacsclient -a "" -tc'
    fi
fi

exists skype && alias skype='apulse skype'
alias l="ls -lha"
alias lt='clear && ls'
alias la='ls -a'
alias tl="clear && l"
exists poweroff && alias turnoff='poweroff'
exists sublime  && alias subl="sublime"
exists sublime2 && alias subl2="sublime2"

#echo "" | gcc -E -march=native -v - | grep -C 1 -i cc
[[ $(hostname) = 'uDH-x201' ]] && alias tmpclear='rm -rf ~/tmp/*'

#git things
if exists git
then
    alias gitupdate='git pull'
    alias gitpush='git add . && git commit && git pull && git push'
    alias gitbranch='git log --pretty=format:"%h %s" --graph'
    alias githistory='gitbranch'
    #alias githisemacs="emacs --eval (magit-log 'master)"
    alias gaussclone='git clone ssh://git@${gaussadd}:2200'
fi

#to sort later
if exists sox
then
    alias cleenmic='sox -d -n trim 0 .1 noiseprof|sox -d -d noisered'
    alias trimsilence='sox - - silence -l 1 0.3 1% -1 2.0 1%'
fi
if [ $(hostname) = 'uDH-x201' ]
then
    alias bluetoothoff="sudo 'rfkill block 0;rfkill block 1'"
    alias bluetoothon="sudo 'rfkill unblock 0;rfkill unblock 1'"
fi
exists cowsay && exists fortune && alias cowfortune='clear && fortune | cowsay -f $(find /usr/share/cowsay*|grep "[.]cow"| shuf -n1)  -W $(($COLUMNS-15))'

# these still need debugging for the & no fork
if murrays
then
    alias unzipdir="ls|sedesc|egrep '[.]zip$'|sed -e 's/^.*$/( mkdir & \&\& mv & & \&\& ( cd & \&\& unzip -q & ) \&\& rm &\/& )/' -e 's/[.]zip[ ][&]/\&/g' -e 's/[.]zip[/]/\//'|sh"
    alias unziptree="find|egrep '[.]zip$'|sedesc|sed -e 's/^.*$/( mkdir & \&\& mv & & \&\& ( cd & \&\& unzip -q *.zip ) \&\& rm &\/& )/' -e 's/[.]zip[ ][&]/\&/g' -e 's/[.]zip[/]\([^/]*[/]\)*/\//'|sh"
    alias unrartree="find|egrep '[.]rar$'|grep -vi part|sedesc|sed -e 's/^.*$/( mkdir & \&\& mv & & \&\& ( cd & \&\& unrar x -idq *.rar ) \&\& rm &\/& )/' -e 's/[.]rar[ ][&]/\&/g' -e 's/[.]rar[/]\([^/]*[/]\)*/\//'|sh"
    alias un7ztree="find|egrep '[.]7z$'|sedesc|sed -e 's/^.*$/( mkdir & \&\& mv & & \&\& ( cd & \&\& 7z x *.7z ) \&\& rm &\/& )/' -e 's/[.]7z[ ][&]/\&/g' -e 's/[.]7z[/]\([^/]*[/]\)*/\//'|sh"
fi

if exists dwarf-fortress
then
    alias dwarf-fortress='dwarf-fortress && clear'
fi

#to remove commits from git
#this will revert to commit f9aff53
#git reset --hard f9aff53
#git push origin --force

# enable typo correciton
setopt correct

# Automatically start X on appropriate machines
[[ $(hostname) = "uDH-tower" ]] && [[ $(tty) = "/dev/tty2" ]] && exec startx
[[ $(hostname) = "uDH-x201"  ]] && [[ $(tty) = "/dev/tty1" ]] && { running X || exec startx }
[[ $(hostname) = "uDH-x201"  ]] && [[ $(tty) = "/dev/tty2" ]] && tmux
[[ $(hostname) = "uDH-deb"   ]] && [[ $(tty) = "/dev/tty2" ]] && exec startx
[[ $(hostname) = "Kitty"     ]] && [[ $(tty) = "/dev/tty1" ]] && { running X || exec startx }
[[ $(hostname) = "uDH-Bot"   ]] && [[ $(tty) = "/dev/tty2" ]] && exec startx

# MOTD
clear
exists cowfortune > /dev/null && cowfortune
