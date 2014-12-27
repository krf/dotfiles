#!/bin/sh

sudo apt-get install -y ack-grep cgdb git kdesdk-scripts vim zsh \
    chromium-browser quassel-client pidgin yakuake zim \
    build-essential clang-3.5 \
    linux-tools-common \
    libjson-perl libxml-parser-perl `# for kdesrc-build` \

sudo apt-get build-dep -y kdelibs5-dev qt5-default
