#!/bin/sh

local CWD=$PWD

echo "*** Fetching new objects from repositories ***"

for i in ./*; do
    echo "*** Checking ${i}... ***"
    test -x $i/.svn && svn up $i
    test -x $i/.git && (cd $i; git fetch; cd $PWD)
done

cd $CWD

echo "*** Done fetching new objects ***"
