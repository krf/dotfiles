#!/bin/sh
#
# Filter objdump output
#
# Usage: objectdump -d OBJECT_FILE | <script>

SHELLCODE="$(cat \
    |grep '[0-9a-f]:' \
    |grep -v 'file' \
    |cut -f2 -d':' \
    |cut -f1-6 -d' ' \
    |tr -s ' ' \
    |tr '\t' ' ' \
    |sed 's/^ //g' \
    |sed 's/ $//g' \
    |paste -d '\n' -s \
    |grep -v "^$" \
)"

echo "$SHELLCODE"

SHELLCODE_SIZE="$(echo "$SHELLCODE" | wc -w)"
echo "Byte count: $SHELLCODE_SIZE" >&2
