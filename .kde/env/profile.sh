#!/bin/bash

# debug output
#set -x

# prepend $HOME/bin to $PATH
if [ -d $HOME/bin ]; then
    PATH=${PATH}:$HOME/bin
    export PATH
fi

# fix eclipse
export GRE_HOME=/tmp

# fix nvidia card painting issues
VGA_INFO="$(lspci | grep 'VGA')"
if [[ "$?" -ne "0" ]]; then
    VGA_INFO="$(/sbin/lspci | grep 'VGA')"
fi
if [[ "$VGA_INFO" =~ "nVidia" ]]; then
    export QT_GRAPHICSSYSTEM=raster
fi
