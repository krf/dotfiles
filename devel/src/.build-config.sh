# KDE Build Environment configuration script
#
# To configure your build environment set LIB_SUFFIX, BASEDIR, BUILDNAME and
# QTDIR as appropriate
#
# The default values provided are for a master/trunk/unstable build in your own
# user directory using your system Qt

# Uncomment if building on a 64 bit system
#export LIB_SUFFIX=64

# Set where your base KDE development folder is located, usually ~/kde
export BASEDIR=~/devel

# Give the build a name, e.g. master, 4.6, debug, etc
if [ -z "$BUILDNAME" ]; then
    export BUILDNAME=master
fi

# Set up which Qt to use
# Use the system Qt, adjust path as required
if [ -z "$QTDIR" ]; then
    export QTDIR=/usr
fi
# Uncomment to use your own build of qt-kde
#export QTDIR=$BASEDIR/inst/master/qt-kde
#export PATH=$QTDIR/bin:$PATH
#export LD_LIBRARY_PATH=$QTDIR/lib:$LD_LIBRARY_PATH
#export PKG_CONFIG_PATH=$QTDIR/lib:$PKG_CONFIG_PATH

# Set up the KDE paths
if [ -z "$KDE_SRC" ]; then 
    export KDE_SRC=$BASEDIR/src
fi
if [ -z "$KDE_BUILD" ]; then
    export KDE_BUILD=$BASEDIR/build
fi
export KDEDIR=$BASEDIR/install/$BUILDNAME
export KDEDIRS=$KDEDIR
export KDEHOME=$BASEDIR/home/.$BUILDNAME
export KDETMP=/tmp/$BUILDNAME-$USER
export KDEVARTMP=/var/tmp/$BUILDNAME-$USER
mkdir -p $KDETMP
mkdir -p $KDEVARTMP

# Add the KDE plugins to the Qt plugins path
export QT_PLUGIN_PATH=$KDEDIR/lib/x86_64-linux-gnu/plugins/:$QT_PLUGIN_PATH
export QML2_IMPORT_PATH=$KDEDIR/lib/x86_64-linux-gnu/qml/:$QT_PLUGIN_PATH

# Export the standard paths to include KDE
export PATH=$KDEDIR/bin:$PATH
export MANPATH=$KDEDIR/share/man:$MANPATH
export LD_LIBRARY_PATH=$KDEDIR/lib/x86_64-linux-gnu:$KDEDIR/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$KDEDIR/lib/pkgconfig:$PKG_CONFIG_PATH

# Export the CMake paths so it searches for KDE in the right places
export CMAKE_PREFIX_PATH=$KDEDIR:$CMAKE_PREFIX_PATH
export CMAKE_LIBRARY_PATH=$KDEDIR/lib:$CMAKE_LIBRARY_PATH
export CMAKE_INCLUDE_PATH=$KDEDIR/include:$CMAKE_INCLUDE_PATH

# Unset XDG to avoid seeing KDE files from /usr
# If unset then you must install shared-mime-info
#unset XDG_DATA_DIRS
#unset XDG_CONFIG_DIRS

# Similar to https://doc.qt.io/qt-5/qstandardpaths.html#setTestModeEnabled, use a separate set of share/cache/config dirs to not mess with original data
#export XDG_DATA_HOME=$HOME/.local-$BUILDNAME
#export XDG_CACHE_HOME=$HOME/.cache-$BUILDNAME
#export XDG_CONFIG_HOME=$HOME/.config-$BUILDNAME

# Fix bug: [11:32:50.540] akonadiserver(267292)/org.kde.pim.akonadiserver: unknown(0): Did not find MySQL server default configuration (mysql-global.conf) @ ?akonadiserver?|?akonadiserver?|?libQt5Core.so.5?|qt_message_output|QDebug::~QDebug|?akonadiserver?|?akonadiserver?|?akonadiserver?|?akonadiserver?|?libQt5Core.so.5?|QMetaCallEvent::placeMetaCall|QObject::event|QCoreApplicationPrivate::notify_helper|?libQt5Core.so.5?|QCoreApplication::notify|QCoreApplication::notifyInternal2|QCoreApplication::sendEvent|QCoreApplicationPrivate::sendPostedEvents|QCoreApplication::sendPostedEvents|?libQt5Core.so.5?
export XDG_CONFIG_DIRS=$KDEDIR/etc/xdg:$XDG_CONFIG_DIRS # at least needed for finding mysql-global.conf for akonadi

export XDG_DATA_DIRS=$KDEDIR/share:$XDG_DATA_DIRS

# Uncomment if you are using Icecream for distributed compiling
#export PATH=/opt/icecream/bin:$PATH

# Report what the environment is set to
echo
echo "*** Configured KDE Build Environment: $BUILDNAME ***"
echo
echo "QTDIR=$QTDIR"
echo "KDEDIR=$KDEDIR"
echo "PATH=$PATH"
echo
echo "MAKEFLAGS=$MAKEFLAGS"
echo
