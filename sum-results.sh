#!/bin/sh

load=$1

tail -16 $load.0.1.data | cut -f1 -d: > $load.sum

for f in $load.*.data; do
    cut -f2- -d: $f | tail -16 | sed 's/\[.*\]//' | paste -d, $load.sum - > $load.sum.tmp
    mv $load.sum.tmp $load.sum
done
sed 's/,/:/' < $load.sum > $load.sum.tmp
mv $load.sum.tmp $load.sum
