for file in $(ls ~/init/.zsh.rc|
										 sed 's/./~\/.zsh.rc\/&/'|
										 egrep "(base|$(hostname))$"|
										 sed 's/-.*//'|
										 uniq|
										 sed 's/.*/if [ -e &-*.$(hostname) ] ; then echo &-*.$(hostname) ; else echo &-*.base ; fi/'|
										 sh)
do
		source $file
done
