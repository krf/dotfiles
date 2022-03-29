#!/usr/bin/env python3

from __future__ import print_function

import os
import shutil
import sys
import tempfile

# convenience functions for print
def print_dbg(data = ""):
    #print("Debug: " + data, file=sys.stderr)
    pass

def print_err(data = ""):
    print(data, file=sys.stderr)
    pass

# others
def show_usage():
    print_err(
"""Swap paths of files or directories.
Usage:
    {0} path1 path2""".format(sys.argv[0])
    )

def move_path(src, tgt):
    print_dbg("Move {0} to {1}".format(src, tgt))
    shutil.move(src, tgt)

def main():
    if (len(sys.argv) < 3):
        print_err("Error: Not enough arguments.")
        print_err()
        show_usage()
        sys.exit(1)

    path1 = sys.argv[1]
    path2 = sys.argv[2]

    # check if both path1 and path2 exist
    for path in [path1, path2]:
        if not os.path.exists(path):
            print_err("Error: Path `{0}` does not exist. Exit.".format(path))
            sys.exit(1)

    # find a safe location where to put the temporary file or directory
    tmpPath = tempfile.mkstemp()[1]
    os.remove(tmpPath) # remove again

    # start swapping of paths
    # move does not care about path1 or path2 being a file or directory
    move_path(path1, tmpPath)
    move_path(path2, path1)
    move_path(tmpPath, path2)
    sys.exit(0)

if __name__ == "__main__":
    main()
