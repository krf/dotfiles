#!/bin/sh

PNAME="kded4"
PID=$(pidof kded4)
if [ $? != 0 ]; then
    echo "Error: ${PNAME} not running"
    exit 1
fi

STMT=$(cat /proc/${PID}/environ | tr '\0' '\n' | grep DBUS_SESSION_BUS)
echo "Using ${STMT}"
export ${STMT}
