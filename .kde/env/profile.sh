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

# fix kmix
export KMIX_PULSEAUDIO_DISABLE=1

# fix nvidia card painting issues
VGA_INFO="$(lspci | grep "VGA")"
if [[ "$VGA_INFO" =~ "nVidia" ]]; then
    export QT_GRAPHICSSYSTEM=raster
fi
