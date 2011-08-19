#!/bin/bash

shift 5

if (hash colordiff 2>/dev/null); then
    colordiff -u $*
else
    diff -u $*
fi
