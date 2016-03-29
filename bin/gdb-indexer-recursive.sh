#!/bin/sh
find . -iname "*.so" | xargs -P $(nproc) -n 1 gdb-indexer index
