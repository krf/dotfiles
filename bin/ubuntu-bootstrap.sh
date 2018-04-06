#!/bin/sh

sudo apt-get install -y ack-grep acpi apt-file automake bzr build-essential ccache clang-3.5 cgdb colordiff deborphan filelight gimp git git-svn gscan2pdf htop imagemagick inxi kdesdk-scripts kdiff3 kolourpaint4 libnofify-bin linux-tools-common mercurial mesa-utils nethogs ninja-build nmap odt2txt pandoc pastebinit pax-utils powertop python-rbtools qt5-doc sloccount texlive-latex-base texlive-fonts-recommended valgrind vim wajig wdiff whois zsh `# CLI` \
    chromium-browser filelight gparted kde-baseapps-bin kleopatra quassel-client pidgin pidgin-plugin-pack virtualbox vlc yakuake zim `# GUI` \
    gperf `# for Qt5 webkit` \
    libdouble-conversion-dev libpcre2-dev `# for Qt5` \
    libreoffice-kde hunspell-de-de `# for libreoffice` \
    libgetopt-euclid-perl `# for git-blame-stats` \
    libjson-perl libxml-parser-perl `# for kdesrc-build` \
    libboost-dev `# for kdevelop` \

sudo apt-get build-dep -y kdelibs5-dev qt5-default
sudo pip install thefuck
