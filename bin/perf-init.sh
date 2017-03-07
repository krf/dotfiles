#!/bin/bash

if [ "$_" = "$0" ]; then
    echo "Do not run this script directly, source it!"
    exit 1
fi

sudo mount -o remount,mode=755 /sys/kernel/debug
sudo mount -o remount,mode=755 /sys/kernel/debug/tracing
echo "-1" | sudo tee /proc/sys/kernel/perf_event_paranoid
echo 0 | sudo tee /proc/sys/kernel/kptr_restrict

export PERF_EXEC_PATH=/home/kfunk/devel/src/linux/tools/perf/
export PATH=$PERF_EXEC_PATH:$PATH

export PATH=$HOME/devel/src/FlameGraph/:$PATH
