#!/bin/sh

# This simple script take the summary file and extract averages from it

file=$1
sumfile=$1.sum

files=($file.*.data)
numfiles=`expr ${#files[@]}`

head -14 $sumfile | cut -f2- -d: | sed 's/,/ +/g' | bc | xargs -i echo "{} / $numfiles" | bc > $sumfile.tmp-avg
head -14 $sumfile | cut -f1 -d: | paste -d: - $sumfile.tmp-avg > $file.avg
rm $sumfile.tmp-avg
