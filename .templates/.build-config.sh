# KDE4 Build Environment configuration script
#
# To configure your build environment set LIB_SUFFIX, BASEDIR, BUILDNAME and
# QTDIR as appropriate
#
# The default values provided are for a master/trunk/unstable build in your own
# user directory using your system Qt

# Set up make
export MAKEFLAGS="-j$(cat /proc/cpuinfo | grep processor | wc -l) $MAKEFLAGS"

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
export QTDIR=/usr
# Uncomment to use your own build of qt-kde
#export QTDIR=$BASEDIR/inst/master/qt-kde
#export PATH=$QTDIR/bin:$PATH
#export LD_LIBRARY_PATH=$QTDIR/lib:$LD_LIBRARY_PATH
#export PKG_CONFIG_PATH=$QTDIR/lib:$PKG_CONFIG_PATH

# Set up the KDE paths
export KDE_SRC=$BASEDIR/src
export KDE_BUILD=$BASEDIR/build
export KDEDIR=$BASEDIR/install/$BUILDNAME
export KDEDIRS=$KDEDIR
export KDEHOME=$BASEDIR/home/.$BUILDNAME
export KDETMP=/tmp/$BUILDNAME-$USER
export KDEVARTMP=/var/tmp/$BUILDNAME-$USER
mkdir -p $KDETMP
mkdir -p $KDEVARTMP

# Add the KDE plugins to the Qt plugins path
export QT_PLUGIN_PATH=$KDEDIR/lib/kde4/plugins:$QT_PLUGIN_PATH

# Do we really need these?
export KDE4_DBUS_INTERFACES_DIR=$KDEDIR/share/dbus-1/interfaces
export PYTHON_SITE_PACKAGES_DIR=$KDEDIR/lib/python2.6/site-packages/PyKDE4

# Export the standard paths to include KDE
export PATH=$KDEDIR/bin:$PATH
export LD_LIBRARY_PATH=$KDEDIR/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$KDEDIR/lib/pkgconfig:$PKG_CONFIG_PATH

# Export the CMake paths so it searches for KDE in the right places
export CMAKE_PREFIX_PATH=$KDEDIR:$CMAKE_PREFIX_PATH
export CMAKE_LIBRARY_PATH=$KDEDIR/lib:$CMAKE_LIBRARY_PATH
export CMAKE_INCLUDE_PATH=$KDEDIR/include:$CMAKE_INCLUDE_PATH

# Unset XDG to avoid seeing KDE files from /usr
# If unset then you must install shared-mime-info
unset XDG_DATA_DIRS
unset XDG_CONFIG_DIRS

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
