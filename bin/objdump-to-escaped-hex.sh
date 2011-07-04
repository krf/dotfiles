#!/bin/sh
#
# Output shellcode (escaped ASCII string) from binary file
#
# Example input:
#   exit.o:     file format elf32-i386
#
#
#   Disassembly of section .text:
#
#   00000000 <.text>:
#      0:   b8 01 00 00 00          mov    $0x1,%eax
#      5:   bb 00 00 00 00          mov    $0x0,%ebx
#      a:   cd 80                   int    $0x80
#
# Example output:
#   "\xb8\x01\x00\x00\x00"
#   "\xbb\x01\x00\x00\x00"
#   "\xcd\x80";
#
# Usage: <script> OBJECT_FILE

objdump -d $1 \
    |grep '[0-9a-f]:' \
    |grep -v 'file' \
    |cut -f2 -d: \
    |cut -f1-6 -d' ' \
    |tr -s ' ' \
    |tr '\t' ' ' \
    |sed 's/ $//g' \
    |sed 's/ /\\x/g' \
    |paste -d '\n' -s \
    |grep -v "^$" \
    |sed 's/^/"/' \
    |sed 's/$/"/g'
