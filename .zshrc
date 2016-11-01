mkdir -p ~/init/logs
# check if $HOST and $USER are system independant, otherwise switch to $(hostname) and $(whoami)
for file in $(ls ~/init/.zsh.rc|
										 sed 's/./~\/init\/.zsh.rc\/&/'|
										 egrep "(base|$HOST|$USER)$"|
						         sed 's/-.*//'|
						         uniq|
						         sed 's/.*/if [ -e &-*.$USER ] ; then echo &-*.$USER ; else if [ -e &-*.$HOST ] ; then echo &-*.$HOST ; else echo &-*.base ; fi fi/'|
										 sh)
do
		source $file > ~/init/logs/$(date +"0%Y-%m-%dT%H:%M:%S").log
done

clear

if [[ -e ~/init/.zsh.rc/motd.$(hostname) ]]
then
		source ~/init/.zsh.rc/motd.$(hostname)
else
		[[ -e ~/init/.zsh.rc/motd.base ]] && source ~/init/.zsh.rc/motd.base
fi
