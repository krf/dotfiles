#!/bin/bash

# Adjust environment for Qt

function show_usage() {
    echo "Usage: $0 path/to/qt/ - ensure that this contains bin/qmake!"
}

if [ -z "$1" ]; then
    show_usage
    echo
    echo "Error: Invalid parameters"
    exit 1
fi

QTDIR="$1"

echo "Trying to find Qt's qmake..."
if "$QTDIR/bin/qmake" --version; then
    echo "Qt found."
else
    echo "Error: Qt not found in $QTDIR."
    exit 1
fi


echo "Setting environment..."
set -x
export QTDIR
export PATH=$QTDIR/bin:$PATH
export LD_LIBRARY_PATH=$QTDIR/lib:$LD_LIBRARY_PATH
