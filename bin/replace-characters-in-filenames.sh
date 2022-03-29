#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Replace certain characters in filenames

# FIXME:
# WARNING: Filenames not escaped (Beware of '`' in filenames, etc.)!

import getopt, os, shutil, string, sys, time

replacements = {
    '├ä': 'Ä',
    '├ñ': 'ä',
    '├╝': 'ü',
    '├û': 'Ö',
    '├Â': 'ö',

    '├½': 'ë',
}

findcmd = 'find . -type d'
movecmd = 'mv --verbose'

def quote_filename(filename):
    return '"%s"' % (
        filename
        .replace('\\', '\\\\')
        .replace('"', '\"')
        .replace('$', '\$')
        .replace('`', '\`')
    )

try:
    opts, args = getopt.getopt(sys.argv[1:], "f", ["force"])
except getopt.GetoptError, err:
    print str(err)
    sys.exit(1)

force = False
for o, a in opts:
    if o in ("-f", "--force"):
        force = True

if len(replacements) > 0:
    findcmd += ' -name "*' + '*" -or -name "*'.join(replacements.keys()) + '*"'

print findcmd

iterations = 0
for file in os.popen(findcmd).readlines():
    name = file[:-1]
    newname = name

    for k, v in replacements.iteritems():
        newname = newname.replace(k, v)

    iterations += 1

    if force:
        os.popen2('%s "%s" "%s"' % (movecmd, name, newname))
    else:
        print 'SIMULATION: %s "%s" "%s"' % (movecmd, quote_filename(name), quote_filename(newname))

time.sleep(1)

print 
if force:
    print "Statistics:"
else:
    print "Simulation statistics:"
print "  Renamed objects:", iterations
