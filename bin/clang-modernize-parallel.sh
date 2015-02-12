#!/bin/bash

CLANG_VERSION=3.7
ROOT_DIR=$(mktemp -d)

find . -iname "*.cpp" -or -iname "*.cc" | \
    xargs -I{} -P$(nproc) clang-modernize-$CLANG_VERSION -serialize-replacements -serialize-dir=$ROOT_DIR $* -include . {} &&
        clang-apply-replacements-$CLANG_VERSION $ROOT_DIR
