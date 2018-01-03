#!/bin/bash

# ag <https://github.com/ggreer/the_silver_searcher>
# usage: ag-replace.sh [search] [replace]
# caveats: will choke if either arguments contain a forward slash
# notes: will back up changed files to *.bak files

DELIM=$(echo -en "\001")
ag -U -0 -l "$1" | \
    xargs -0 perl -e "s${DELIM}${1}${DELIM}${2}${DELIM}g" -pi
