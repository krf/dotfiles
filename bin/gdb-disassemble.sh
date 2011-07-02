#!/bin/bash
if [ -z "${1}" ] || [ -z "${2}" ]; then
    echo "Usage: ${0} <object> <frame>"
    exit 1
fi

/usr/bin/gdb ${1} -q <<EOF 2>&1
    disassemble ${2}
EOF
