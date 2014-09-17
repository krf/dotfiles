#!/bin/sh
find . -iname "*.so" | xargs gdb-indexer index
