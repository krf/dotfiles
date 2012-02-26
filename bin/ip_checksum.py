#!/usr/bin/env python

import struct
import sys

def carry_around_add(a, b):
    c = a + b
    return (c & 0xffff) + (c >> 16)

def checksum(msg):
    s = 0
    for i in range(0, len(msg), 2):
        w = (ord(msg[i]) << 8) + (ord(msg[i+1]))
        s = carry_around_add(s, w)
        print "0x%04x" % s
    return ~s & 0xffff

def checksum_str(payload):
    data = payload.split()
    data = map(lambda x: int(x,16), data)
    data = struct.pack("%dB" % len(data), *data)
    return checksum(data)

data = sys.argv[1]

print "Checksum: 0x%04x" % checksum_str(data)

