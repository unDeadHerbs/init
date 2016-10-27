#[[ $(tty) = "/dev/tty1" ]] && ( cd ~/init ; until git pull ; do ; done)&
#[[ $(tty) = "/dev/tty2" ]] && ( cd ~/init ; until git pull ; do ; done)&

# Add aliases for programs that are installed on single machines
if [ $(hostname) = 'uDH-x201' ]
then
    alias sublime="~/Sublime_Text_3/sublime_text"
    alias sublime2="~/Sublime_Text_2/sublime_text"
    alias steam="steam/steam/steam.sh"

fi

#echo "" | gcc -E -march=native -v - | grep -C 1 -i cc

#git things
if exists git
then
    alias gitupdate='until git pull; do; done'
    alias gitpush='git add . && git commit && git pull && git push'
    alias gitbranches='git log --pretty=format:"%h %s" --graph'
    alias githistory='gitbranches'
    #alias githisemacs="emacs --eval (magit-log 'master)"
    #alias gaussclone='git clone ssh://git@${gaussadd}:2200'
fi

# these still need debugging for the & no fork
if murrays
then
    alias unzipdir="ls|sedesc|egrep '[.]zip$'|sed -e 's/^.*$/( mkdir & \&\& mv & & \&\& ( cd & \&\& unzip -q & ) \&\& rm &\/& )/' -e 's/[.]zip[ ][&]/\&/g' -e 's/[.]zip[/]/\//'|sh"
    alias unziptree="find|egrep '[.]zip$'|sedesc|sed -e 's/^.*$/( mkdir & \&\& mv & & \&\& ( cd & \&\& unzip -q *.zip ) \&\& rm &\/& )/' -e 's/[.]zip[ ][&]/\&/g' -e 's/[.]zip[/]\([^/]*[/]\)*/\//'|sh"
    alias unrartree="find|egrep '[.]rar$'|grep -vi part|sedesc|sed -e 's/^.*$/( mkdir & \&\& mv & & \&\& ( cd & \&\& unrar x -idq *.rar ) \&\& rm &\/& )/' -e 's/[.]rar[ ][&]/\&/g' -e 's/[.]rar[/]\([^/]*[/]\)*/\//'|sh"
    alias un7ztree="find|egrep '[.]7z$'|sedesc|sed -e 's/^.*$/( mkdir & \&\& mv & & \&\& ( cd & \&\& 7z x *.7z ) \&\& rm &\/& )/' -e 's/[.]7z[ ][&]/\&/g' -e 's/[.]7z[/]\([^/]*[/]\)*/\//'|sh"
fi

#to remove commits from git
#this will revert to commit f9aff53
#git reset --hard f9aff53
#git push origin --force

# enable typo correciton

# MOTD
