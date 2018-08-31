#!/bin/bash

# Disable leak detection in ASAN, otherwise the kdev-pg-qt binary will return with non-zero return code
ASAN_OPTIONS=detect_leaks=0

while [[ $# > 0 ]]
do
    key="$1"

    case $key in
    -a) ALL=1; shift; ;;
    -c) CLEAN=1; shift; ;;
    -s) SANITIZE=1; shift; ;;
    -r) REBASE=1; shift; ;;
    *) ;;
    esac
done

TOP_SRC="$HOME/devel/src/kf5"
TOP_BUILD="$HOME/devel/build/kf5"

if [[ -n "$ALL" ]]; then
    KDEVELOP_PROJECTS="$(kdevelop-list-qt5-repos.sh)"
else
    KDEVELOP_PROJECTS="kdevelop-pg-qt $(kdevelop-list-released-repos.sh)"
fi
KDEVELOP_PROJECTS="${KDEVELOP_PROJECTS//$'\n'/ }"

if [[ -n "$KDEV_EXTRA_PROJECTS" ]]; then
    KDEVELOP_PROJECTS="$KDEVELOP_PROJECTS $KDEV_EXTRA_PROJECTS"
fi

echo "Building projects: $KDEVELOP_PROJECTS"

if [[ -z "$KDEDIR" ]]; then
    echo "KDEDIR empty, defaulting to $HOME/devel/install/kf5"
    KDEDIR="$HOME/devel/install/kf5"
fi

set -e
set -x

pushd $TOP_SRC

echo $KDEV_SUFFIX
for project in $KDEVELOP_PROJECTS; do
    if [[ "$project" == "kdevplatform" ]] && [[ "$KDEV_TARGET" != "5.1" ]]; then
        continue
    fi

    dir=${project}${KDEV_SUFFIX}
    git-new-workdir $project $dir || git clone git://anongit.kde.org/${project} || true

    mkdir $dir || true
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
    cmake -DCMAKE_INSTALL_PREFIX=$KDEDIR ${extraArgs[@]} -G Ninja $TOP_SRC/$dir
    ninja install
    popd
done

popd

