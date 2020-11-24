#!/bin/sh
find $1 -iname "*.so" | xargs -P $(nproc) -n 1 gdb-indexer index
