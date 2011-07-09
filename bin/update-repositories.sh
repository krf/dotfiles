#!/bin/sh
#
# This will update all repositories in $PWD/* (no recursive)
# Supported types: CVS, SVN, Git, HG
#
# Additional script support for: $PWD/*/.update-procedure.sh
#   This script (if existant) will called directly
#
#   Example script (placed in Qt5 repository)
#     $ cat qt5/.update-procedure.sh
#
#     #!/bin/sh
#
#     THIS_DIR="$(cd $(dirname $0) && pwd)"
#     ${THIS_DIR}/qtrepotools/bin/qt5_tool -p
#

local CWD=$PWD

echo "*** Fetching new objects from repositories ***"

for i in ./*; do
    # continue if $i is no directory
    test -d "$i" || continue

    echo "*** Checking ${i}... ***"

    # call update script if there is any
    test -x "$i/.update-procedure.sh" && (
        cd "$i"
        ./.update-procedure.sh
        cd "$PWD"
    )

    # update repository depending on VCS used
    test -x "$i/.svn" &&
        svn up "$i"
    test -x "$i/.git" && (
        cd "$i"
        git fetch --all
        cd "$PWD"
    )
    test -x "$i/CVS" && (
        cd "$i"
        cvs up
        cd "$PWD"
    )
    test -x "$i/.hg" && (
        cd "$i"
        hg update
        cd "$PWD"
    )
done

cd $CWD

echo "*** Done fetching new objects ***"
