#!/bin/sh
for dir in ./*/
do
    unrar e -o- $dir/*.rar
done
