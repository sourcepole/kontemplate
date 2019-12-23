#!/bin/sh

help() {
   echo 'usage: merge-from-upstream.sh patch_URL'
   echo '       merge-from-upstream.sh --help'
   echo
   echo '    Will apply the patch from the given patch_URL'
   echo '    and append a "Original commit: patch_URL" to'
   echo '    the commit message.'
   echo
   echo '    Example:'
   echo
   echo '        ./merge-from-upstream.sh https://git.tazj.in/patch/ops/kontemplate?id=98f8b660e225349de2a1dc8f578503fc46c4ba83'
   echo
   exit 1
}

[ "$1" == "--help" ] || [ "$1" == "" ] && help
patch_URL="$1"
original_commit_link="Original commit: $patch_URL"

# thanks Robert Wahler: https://stackoverflow.com/a/9507417
#
wget "$patch_URL" | git am -3 -k
if [ "$?" != "0" ]; then
   echo "ERROR: something went wrong. Please check the"
   echo "       output above and after you have fixed stuff"
   echo "       append the followin line to the commit message:"
   echo
   echo "$original_commit_link"
   echo
else
   # thanks Edward Thomson: https://stackoverflow.com/a/42857774
   #
   OLD_MSG=$(git log --format=%B -n1)
   git commit --amend -m"$OLD_MSG" -m"$original_commit_link"
fi
