for file in $(ls ~/init/.zsh.rc|
										 sed 's/./~\/.zsh.rc\/&/'|
										 egrep "(base|$(hostname)|$USER)$"|
						         sed 's/-.*//'|
						         uniq|
						         sed 's/.*/if [ -e &-*.$USER ] ; then echo &-*.$USER ; else if [ -e &-*.$(hostname) ] ; then echo &-*.$(hostname) ; else echo &-*.base ; fi fi/'|
										 sh)
do
		source $file
done

clear

if [[ -e ~/init/.zsh.rc/99-motd.$(hostname) ]]
then
		~/init/.zsh.rc/99-motd.$(hostname)
else
		[[ -e ~/init/.zsh.rc/99-motd.base ]] && ~/init/.zsh.rc/99-motd
fi
