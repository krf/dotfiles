#!/bin/sh

if [ -z "$1" ]; then
    echo "Usage: $0 path1 [path2 [path3 [...]]]"
fi

# check parameters
for path in "$@"; do
    if [ ! -w "$path" ]; then
        echo "Invalid path: ${path}. Exit"
        exit
    fi
done

# save prefix for renaming
IFS=
echo -n "Enter prefix: "
read prefix
unset IFS

# check if the text entered is okay
echo "Prefix is \"${prefix}\""
echo "Prefix will be added to following paths: $*"
echo -n "Proceed renaming? [y/n]: "
read do_proceed
if [ "$do_proceed" != "y" ]; then
    echo "Aborted."
    exit
fi

for path in "$@"; do
    mv -v "${path}" "${prefix}${path}"
done
