#!/bin/sh
if [ "$#" != 2 ]; then
    echo "Usage: $0 OBJECT_FILE SYMBOL"
    return;
fi

OBJECT_FILE="$1"
SYMBOL="$2"

objdump -d $OBJECT_FILE | sed-from-until.sh "\<$SYMBOL\>.:" "\w+"
