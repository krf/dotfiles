#!/bin/sh

SHELLCODE_ASCII="$(cat | sed 's/ /\\x/g' | sed 's/^/"\\x/g' | sed 's/$/"/g')"
echo "$SHELLCODE_ASCII"
