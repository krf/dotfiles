#!/bin/sh
#
# This script purges all the packages that have a status different from ii
# 2005 - Julien Valroff <julien@kirya.net>
#
# Changelog:
#  0.01 (16/06/2005)
#   * Initial release
#  0.02 (16/10/2005)
#   * Fixed possible symlink attacks (uses mktemp)
#   * Updated regexp
#  0.03 (27/11/2005)
#   * Simplified usage (no question asked)
#
# Source:
#  http://www.kirya.net/tips/purge-all-packages/
#
#
# Aptitude alternative:
#  aptitude purge "~c"


TMPFILE=`mktemp` || exit 1
dpkg -l | grep -v '^ii ' | awk '{print $2}' > $TMPFILE

count=$(cat $TMPFILE|wc -l)
count=$(expr $count - 5)

if [ $count -eq 0 ]; then
   echo "No package to purge."
else
    var=$(dpkg -l | grep -v '^ii ' | awk '{print $2}' | tail -n $count)
    sudo aptitude purge $var
fi

rm -f $TMPFILE
