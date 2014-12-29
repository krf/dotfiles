#!/bin/sh

sudo apt-get install -y ack-grep cgdb git kdesdk-scripts pastebinit vim zsh \
    chromium-browser quassel-client pidgin virtualbox yakuake zim \
    build-essential clang-3.5 \
    linux-tools-common mesa-utils \
    gperf `# for Qt5 webkit` \
    libjson-perl libxml-parser-perl `# for kdesrc-build` \
    libboost-dev `# for kdevelop` \

sudo apt-get build-dep -y kdelibs5-dev qt5-default
