#!/bin/sh

sudo apt-get install -y ack-grep acpi bzr build-essential clang-3.5 cgdb deborphan git git-svn imagemagick inxi kdesdk-scripts kdiff3 linux-tools-common mercurial mesa-utils nethogs ninja-build pastebinit powertop valgrind vim wajig zsh `# CLI` \
    chromium-browser gparted kde-baseapps-bin kleopatra quassel-client pidgin virtualbox yakuake zim `# GUI` \
    gperf `# for Qt5 webkit` \
    hunspell-de-de `# for libreoffice` \
    libgetopt-euclid-perl `# for git-blame-stats` \
    libjson-perl libxml-parser-perl `# for kdesrc-build` \
    libboost-dev `# for kdevelop` \

sudo apt-get build-dep -y kdelibs5-dev qt5-default
