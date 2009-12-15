#!/bin/bash
#
# Keep track of history in /etc
# Author: Kevin Funk
#

if [ "$UID" -ne "0" ]; then
    echo "Must be root to run this script"
    exit 1
fi

if [ -z "$1" ]; then
    echo "Usage: etc-commit.sh commit-msg"
    echo "Keeps track of history in /etc"
    echo "Please provide a useful commit message of the changes done"
    exit 1
fi

cd /etc
git add .

git status
if [ "$?" -ne "0" ]; then
    exit
fi

git diff
read -p "Continue? Commit message will be: $1 (Ctrl-C to abort) " dummy_var

git commit -a -m $1
