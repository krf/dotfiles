#!/bin/sh

if [ -n "$KDEV_SUFFIX" ]; then
    echo kdevplatform
fi

for i in kdevelop kdev-python kdev-php; do
    echo $i
done
