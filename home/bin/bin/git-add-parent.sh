#!/usr/bin/env bash

# TODO: validate the input a little
# is $1 a valid commit?
# are there exactly $1 arguments?
# is this even a git repo?

branch_name=`git branch --show-current`
# due to a bug in git-show we need to extract the head manually
current_hash=`git show --pretty=format:%H|head -1`
echo "Modifying $current_hash on $branch_name"
message=`git log --pretty=format:%s -1`
old_parents=`git show --pretty=format:%P|head -1`
git checkout --detach
#echo "old parents $(echo $old_parents|sed 's,[^ ]*,-p &,g')"
#echo "new parent -p $1"
new_hash=`git commit-tree @^{tree} $(echo $old_parents|sed 's,[^ ]*,-p &,g') -p $1 -m "$message"`
#echo "new hash $new_hash"
git checkout $new_hash
git b -D $branch_name
git b $branch_name
git checkout $branch_name
