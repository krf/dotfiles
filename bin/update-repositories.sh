#!/bin/sh
#
# This will update all repositories in $PWD/* (no recursive)
# If $PWD already contains a repository, only this is updated
#
# Supported types: CVS, SVN, Git, HG
#
# Additional script support for: $PWD/*/.update-procedure.sh
#   This script (if existant) will be called directly
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
        ./.update-procedure.sh && return 0

    # update repository depending on VCS used
    test -x ".svn" &&
        svn up && return 0
    test -x ".git" &&
        git fetch --all && return 0
    test -x "CVS" &&
        cvs up && return 0
    test -x ".hg" &&
        hg update && return 0

    return 1
}

# check each subdirectory for version control systems
check_subdirectories()
{
    local INITIAL_PWD="$PWD"
    for i in ./*; do
        # continue if $i is no directory
        test -d "$i" || continue

        echo "*** Checking ${i}... ***"

        # enter directory, update, reset cwd
        cd "$i"
        update_pwd
        cd "$INITIAL_PWD"
    done
}

# start of main routine
local INITIAL_PWD="$PWD"

echo "*** Fetching new objects from repositories ***"

# try to update cwd first
update_pwd

# if current working directory has no repository, check subdirectories
if [ $? -eq 1 ]; then
    echo "*** Checking subdirectories ***"
    check_subdirectories
else
    echo "*** Repository in CWD updated ***"""
fi

# be sure to return to old CWD
cd "$INITIAL_PWD"

echo "*** Done fetching new objects ***"
