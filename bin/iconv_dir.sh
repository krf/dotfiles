#!/bin/bash

if [ $# -lt 3 ]
then
    echo "$0 dir from_charset to_charset"
    exit
fi

for f in $1/*
do
    if test -f $f
    then
        echo -e "\nConverting $f"
        /bin/mv $f $f.old
        iconv -f $2 -t $3 $f.old > $f
    else
        echo -e "\nSkipping $f - not a regular file";
    fi
done
