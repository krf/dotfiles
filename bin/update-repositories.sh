#!/bin/sh
#
# This will update all repositories in $PWD/* (non-recursive)
# If $PWD already contains a repository, only this is updated.
# Recursive-mode can be simulated easily, see script support.
#
# Usage:
#   $ cd path/to/src/ # should contain various repositories in sub-folders
#   $ update-repositories.sh # will automatically update all repositories
#
# Supported repository types:
#   * CVS
#   * SVN
#   * Git
#   * Git-SVN
#   * HG
#
# Script support
#   Additional script support for the following files: $PWD/*/.update-procedure.sh
#   These scripts (if existant) will be called instead of using the VCS tools.
#
#   Example script (placed in Qt5 repository):
#     $ cat qt5/.update-procedure.sh
#
#     #!/bin/sh
#     ./qtrepotools/bin/qt5_tool -p
#
#   Example script if you want to do recursive updating:
#     $ cat other-sources/.update-procedure.sh
#
#     #!/bin/sh
#     update-repositories.sh # invoke calling script again
#

# update current working directory
update_pwd()
{
    # call update script if there is any
    test -x ".update-procedure.sh" &&
        echo "Calling $PWD/.update-procedure.sh" &&
        $PWD/.update-procedure.sh && return 0

    # update repository depending on VCS used
    test -x ".svn" &&
        svn up && return 0
    test -x ".git/svn" &&
        git svn fetch && return 0
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

        echo "*** Checking ${i} ***"

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
