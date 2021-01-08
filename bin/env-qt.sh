#!/bin/bash

# Adjust environment for Qt. Needs to be sourced, e.g. 'source FILE'

function __env-qt_show_usage() {
    echo "Usage: source $0 path/to/qt/ - ensure that this contains bin/qmake!"
}

function __env-qt_main() {
    if [ -z "$1" ]; then
        __env-qt_show_usage
        echo
        echo "Error: Invalid parameters"
        return
    fi

    if [ "$0" = "$BASH_SOURCE" ]; then
        # this where I found the above check: https://stackoverflow.com/a/2684300/592636
        echo "Do not run this script directly, source it!"
        return
    fi

    QTDIR="$(readlink -m $1)"

    echo "Trying to find Qt's qmake..."
    if "$QTDIR/bin/qmake" --version; then
        echo "Qt found."
    else
        echo "Error: Qt not found in $QTDIR."
        return
    fi

    echo "Setting environment."
    export QTDIR
    export CMAKE_PREFIX_PATH=$QTDIR:$CMAKE_PREFIX_PATH
    export PATH=$QTDIR/bin:$PATH
    export QT_PLUGIN_PATH=$QTDIR/plugins:$QT_PLUGIN_PATH
    export LD_LIBRARY_PATH=$QTDIR/lib:$LD_LIBRARY_PATH
    export QML2_IMPORT_PATH=$QTDIR/qml:$QML2_IMPORT_PATH
    # WTH is this needed???
    export QT_QPA_PLATFORM_PLUGIN_PATH=$QTDIR/plugins/platforms/
    echo "Done."
}

__env-qt_main $*
unset -f __env-qt_show_usage
unset -f __env-qt_main
