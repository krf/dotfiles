#!/usr/bin/env python

from __future__ import print_function

import os
import sys
from subprocess import Popen, PIPE

def print_usage():
    print("Usage: {0} SYMBOL LIBRARY [LIBRARY]...".format(sys.argv[0]))

def print_symbols(searchSymbol, searchLibraries):
    cmd = ["objdump", "-CT"] + searchLibraries
    p = Popen(cmd, stdout=PIPE)
    stdout = p.communicate()[0].rstrip()

    # parse
    lastFile = ""
    for line in stdout.splitlines():
        if "file format" in line:
            fileName = line.split(":")[0]
            lastFile = fileName
            continue

        if ".text" in line:
            # filter the symbol from the objdump line
            words = line.split(" ")
            startIndexOfSymbol = len(words) - words[::-1].index("")
            symbol = " ".join(words[startIndexOfSymbol:])

            # we're only interested in the part before '('
            if searchSymbol in symbol.split("(")[0]:
                print("{0}: {1}".format(lastFile, symbol))

if __name__ == "__main__":
    if len(sys.argv) <= 2:
        print_usage()
        sys.exit(1)

    searchSymbol = sys.argv[1]
    searchLibraries = sys.argv[2:]

    # call
    print_symbols(searchSymbol, searchLibraries)
    sys.exit(0)
