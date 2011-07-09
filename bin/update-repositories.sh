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

# update current working directory
update_pwd()
{
    # call update script if there is any
    test -x ".update-procedure.sh" &&
        ./.update-procedure.sh

    # update repository depending on VCS used
    test -x ".svn" &&
        svn up
    test -x ".git" &&
        git fetch --all
    test -x "CVS" &&
        cvs up
    test -x ".hg" &&
        hg update
}

# start of main routine
local INITIAL_PWD=$PWD

echo "*** Fetching new objects from repositories ***"

# check each subdirectory for version control systems
for i in ./*; do
    # continue if $i is no directory
    test -d "$i" || continue

    echo "*** Checking ${i}... ***"

    # enter directory, update, reset cwd
    cd "$i"
    update_pwd
    cd "$INITIAL_PWD"
done

# be sure to return to saved CWD
cd "$INITIAL_PWD"

echo "*** Done fetching new objects ***"
