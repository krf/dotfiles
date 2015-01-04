#!/bin/sh

sudo apt-get install -y ack-grep acpi build-essential clang-3.5 cgdb git git-svn kdesdk-scripts kdiff3 linux-tools-common mesa-utils nethogs ninja-build pastebinit powertop vim zsh `# CLI` \
    chromium-browser gparted quassel-client pidgin virtualbox yakuake zim `# GUI` \
    gperf `# for Qt5 webkit` \
    libjson-perl libxml-parser-perl `# for kdesrc-build` \
    libboost-dev `# for kdevelop` \

sudo apt-get build-dep -y kdelibs5-dev qt5-default
