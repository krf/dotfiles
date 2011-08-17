#!/bin/bash

shift 5

if hash colordiff; then
    colordiff -u $*
else
    diff -u $*
fi
