# check if $HOST and $USER are system independant, otherwise switch to $(hostname) and $(whoami)
for file in $(ls ~/init/.zsh.rc|
										 sed 's/./~\/.zsh.rc\/&/'|
										 egrep "(base|$HOST|$USER)$"|
						         sed 's/-.*//'|
						         uniq|
						         sed 's/.*/if [ -e &-*.$USER ] ; then echo &-*.$USER ; else if [ -e &-*.$HOST ] ; then echo &-*.$HOST ; else echo &-*.base ; fi fi/'|
										 sh)
do
		source $file
done

clear

if [[ -e ~/init/.zsh.rc/motd.$(hostname) ]]
then
		~/init/.zsh.rc/motd.$(hostname)
else
		[[ -e ~/init/.zsh.rc/motd.base ]] && ~/init/.zsh.rc/motd.base
fi
