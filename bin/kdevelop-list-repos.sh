#!/bin/sh

echo kdevelop-pg-qt # needs to come first
# note: only kdev projects; don't print kdevelop-pg-qt again; ignore unmaintained or dead repositories
# note: little hack: just sort by name, that gives us a order which respects the dependencies
sed -nr 's/^.+project identifier=\"(.+)\".+$/\1/p' /home/kfunk/devel/src/kf5/kde_projects.xml \
    | grep kdev \
    | grep -v kdevelop-pg-qt \
    | grep -Ev "kdev-cppcheck|kdev-qmljs|kdev-clang|kdev-perforce|kdev-qmake|kdev-mercurial|kdev-www" \
    | sort --version-sort
