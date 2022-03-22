#!/bin/sh

set -e

sudo apt-get install -y ack silversearcher-ag acpi apt-file automake bzr build-essential ccache cgdb colordiff deborphan dos2unix git git-lfs git-svn gscan2pdf htop imagemagick inxi kdesdk-scripts libnotify-bin lm-sensors linux-tools-common linux-tools-generic mercurial mesa-utils nethogs nmap odt2txt openconnect pandoc pastebinit pax-utils powertop qt5-doc sloccount sshuttle texlive-latex-base texlive-fonts-recommended unp unrar valgrind vim wajig wdiff whois zsh `# CLI` \
    chromium-browser filelight gimp gparted kdiff3 kleopatra kmail kolourpaint korganizer quassel-client pidgin pidgin-plugin-pack virtualbox virtualbox-qt vlc yakuake zim `# GUI` \
    bison clang cmake lld flex g++ ninja-build qmlscene qt5-qmake `# building` \
    fonts-dejavu-extra `# for pandoc with mainfont DejavuSans` \
    gperf `# for Qt5 webkit` \
    libxshmfence-dev/impish `# for Qt6 WebEngine` \
    libdouble-conversion-dev libpcre2-dev `# for Qt5` \
    libreoffice-kde hunspell-de-de `# for libreoffice` \
    libgetopt-euclid-perl `# for git-blame-stats` \
    libjson-perl libxml-parser-perl `# for kdesrc-build` \
    libboost-thread-dev libcurlpp-dev libxerces-c-dev `# for libkolabxml` \
    intltool libaspell-dev libboost-dev libdrm-dev libgif-dev libgl-dev libical-dev libegl-dev libfam-dev libgcrypt20-dev libphonenumber-dev libpolkit-gobject-1-dev libpolkit-agent-1-dev libxml2-dev libxslt-dev libsm-dev libssl-dev `# for Qt/KDE projects` \

sudo apt-get build-dep -y kdevelop kmail kwin korganizer qt5-default
