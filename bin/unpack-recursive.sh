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
    elif [[ "$file" == *.7z ]]; then
        echo "Unzipping file: $file"
        7za e -o- $file
    elif [[ "$file" == *.rar ]]; then
        echo "Unraring file: $file"
        unrar e -o- $file
    elif [ -d "$file" ]; then
        unpack-recursive.sh $file/*
    fi
done

exit 0
