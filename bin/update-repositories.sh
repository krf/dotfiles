#!/bin/sh

local CWD=$PWD

echo "*** Fetching new objects from repositories ***"

for i in ./*; do
    # continue if $i is no directory
    test -d "$i" || continue

    echo "*** Checking ${i}... ***"
    # update repository depending on VCS used
    test -x "$i/.svn" &&
        svn up "$i"
    test -x "$i/.git" &&
        (cd "$i"; git fetch; cd "$PWD")
done

cd $CWD

echo "*** Done fetching new objects ***"
