mkdir -p ~/init/logs
# check if $HOST and $USER are system independant, otherwise switch to $(hostname) and $(whoami)
for file in $(ls ~/.zshrc.d|
                  sed 's/./~\/.zshrc.d\/&/'|
                  egrep "(base|$HOST|$USER)$"|
                  sed 's/-.*//'|
                  uniq)
do
    if echo "ls $file-*.$USER"|sh > /dev/null 2>&1; then
	source ${~file}-*.$USER
    else if echo "ls $file-*.$HOST"|sh >/dev/null 2>&1 ; then
	source ${~file}-*.$HOST
    else if echo "ls $file-*.base"|sh > /dev/null 2>&1; then
        source ${~file}-*.base
    fi; fi; fi
done
#    source $file
#    #|sed "s/./[$(date +"%H:%M:%S")]: &/" >> ~/init/logs/$(date +"0%Y-%m-%d").log
#    #2>&1|sed "s/./[$(date +"%H:%M:%S")]: &/" >> ~/init/logs/$(date +"0%Y-%m-%d").error.log

clear

if [[ -e ~/.motd/$(hostname) ]]
then
    source ~/.motd/$(hostname)
else
    if [[ -e ~/.motd/$(whoami) ]]
    then
	source ~/.motd/$(whoami)
    else
	[[ -e ~/.motd/base ]] && source ~/.motd/base
    fi
fi

PATH="/home/udh/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/udh/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/udh/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/udh/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/udh/perl5"; export PERL_MM_OPT;
