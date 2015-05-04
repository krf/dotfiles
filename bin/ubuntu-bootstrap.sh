#!/bin/sh

sudo apt-get install -y ack-grep acpi apt-file automake bzr build-essential ccache clang-3.5 cgdb deborphan filelight gimp git git-svn htop imagemagick inxi kdesdk-scripts kdiff3 kolourpaint4 linux-tools-common mercurial mesa-utils nethogs ninja-build pandoc pastebinit powertop python-rbtools qt5-doc sloccount texlive-latex-base texlive-fonts-recommended valgrind vim wajig whois zsh `# CLI` \
    chromium-browser filelight gparted kde-baseapps-bin kleopatra quassel-client pidgin pidgin-plugin-pack virtualbox vlc yakuake zim `# GUI` \
    gperf `# for Qt5 webkit` \
    hunspell-de-de `# for libreoffice` \
    libgetopt-euclid-perl `# for git-blame-stats` \
    libjson-perl libxml-parser-perl `# for kdesrc-build` \
    libboost-dev `# for kdevelop` \

sudo apt-get build-dep -y kdelibs5-dev qt5-default
