#!/bin/bash
#
# Unpack all files in a directory or for a list of files
#
# Usage: unpack-recursive.sh [FILE]...
#   (uses current directory when no arguments are given)

FILES="$@"

if [ -z "$FILES" ]; then
    FILES="*"
fi

for file in $FILES; do
    echo "Checking file: $file"

    if [[ "$file" == *.tar ]]; then
        echo "Untaring file: $file"
        tar xf $file &&
            echo "Deleting file: $file" &&
            rm $file
    fi

    if [ -d "$file" ]; then
        unrar e -o- $file/*.rar
    fi
done

exit 0
