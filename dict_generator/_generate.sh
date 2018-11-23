#!/bin/bash

set -e
#set -x

rm -rf tmp
mkdir tmp

g++ -I. -std=c++11 -O2 -Wall -Wextra -o tmp/dictgen src/dict-generate.cpp

for d in input/*/ ; do

	name=$(basename $d)
	evalstring="./tmp/dictgen -b -o ../dictionaries/$name.dct"
    
	for f in "$d/"* ; do
		evalstring+=" $f"
	done

	eval $evalstring

done

rm -rf tmp