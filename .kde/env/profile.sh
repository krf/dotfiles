#!/bin/sh

if [ -d $HOME/bin ]; then
    PATH=${PATH}:$HOME/bin
    export PATH
fi

# fix eclipse
export GRE_HOME=/tmp
