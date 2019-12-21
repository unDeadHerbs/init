mkdir -p ~/init/logs
# check if $HOST and $USER are system independant, otherwise switch to $(hostname) and $(whoami)
for file in $(ls ~/.zshrc/d|
                  sed 's/./~\/.zshrc.d\/&/'|
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

PATH="/home/udh/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/udh/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/udh/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/udh/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/udh/perl5"; export PERL_MM_OPT;
