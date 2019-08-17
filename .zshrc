mkdir -p ~/init/logs
# check if $HOST and $USER are system independant, otherwise switch to $(hostname) and $(whoami)
for file in $(ls ~/.zsh.rc|
                  sed 's/./~\/.zsh.rc\/&/'|
                  egrep "(base|$HOST|$USER)$"|
                  sed 's/-.*//'|
                  uniq|
                  sed "s/.*/if [ -e &-*.$USER ] ; then echo &-*.$USER ; else if [ -e &-*.$HOST ] ; then echo &-*.$HOST ; else echo &-*.base ; fi fi/"|
                  sh)
do
    source $file
    #|sed "s/./[$(date +"%H:%M:%S")]: &/" >> ~/init/logs/$(date +"0%Y-%m-%d").log
    #2>&1|sed "s/./[$(date +"%H:%M:%S")]: &/" >> ~/init/logs/$(date +"0%Y-%m-%d").error.log
done

clear

if [[ -e ~/.motd/$(hostname) ]]
then
    source ~/.motd/$(hostname)
else
    [[ -e ~/.motd/base ]] && source ~/.motd/base
fi
