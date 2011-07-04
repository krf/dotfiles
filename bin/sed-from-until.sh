#!/bin/sh
if [ "$#" != 2 ]; then
    echo "Usage: <script> FROM_REGEXP UNTIL_REGEXP"
    echo
    echo "Prints out all lines within FROM and UNTIL, ignores others"
    return
fi

FROM=$1
UNTIL=$2

sed -n "/${FROM}/,/\<word\>\|^$\|${UNTIL}/p"
