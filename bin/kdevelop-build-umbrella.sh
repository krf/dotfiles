#!/bin/bash

# Disable leak detection in ASAN, otherwise the kdev-pg-qt binary will return with non-zero return code
ASAN_OPTIONS=detect_leaks=0

while [[ $# > 0 ]]
do
    key="$1"

    case $key in
    -c)
        CLEAN=1
        shift
        ;;
    -s)
        SANITIZE=1
        shift
        ;;
    -r)
        REBASE=1
        shift
        ;;
    *)
        ;;
    esac
    shift
done

TOP_SRC="$HOME/devel/src/kf5"
TOP_BUILD="$HOME/devel/build/kf5"
KDEVELOP_PROJECTS="kdevelop-pg-qt kdevplatform kdevelop kdev-python kdev-php"

set -e
set -x

pushd $TOP_SRC

echo $KDEV_SUFFIX
for project in $KDEVELOP_PROJECTS; do
    dir=${project}${KDEV_SUFFIX}
    git-new-workdir $project $dir || true

    pushd $dir
    git checkout $KDEV_TARGET

    if [[ -n "$REBASE" ]]; then
        git pull --rebase
    fi
    popd

    builddir=$TOP_BUILD/$dir
    if [[ -n "$CLEAN" ]]; then
        rm -rf $builddir
    fi
    mkdir -p $builddir

    pushd $builddir

    extraArgs=""
    if [[ -n "$SANITIZE" ]]; then
        extraArgs=(-DECM_ENABLE_SANITIZERS="address" -DCMAKE_CXX_FLAGS="-fsanitize=address -fsanitize-memory-track-origins -fsanitize=leak -fsanitize=undefined -fno-omit-frame-pointer -fno-optimize-sibling-calls -fno-sanitize=alignment")
    fi

    echo $extraArgs
    cmake -DCMAKE_INSTALL_PREFIX=$KF5 ${extraArgs[@]} -G Ninja $TOP_SRC/$dir
    ninja install
    popd
done

popd

