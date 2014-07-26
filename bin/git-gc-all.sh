#!/bin/bash
find . -type d -name '.git' -print0 | \
    xargs -0 -P4 -I{} sh -c 'cd {}; git gc; echo done {}'
