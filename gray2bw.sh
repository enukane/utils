#!/bin/sh

if [ $# != 2 ]; then
	echo "usage: gray2bw.sh [input] [output]"
	exit 1
fi
convert $1 -colorspace gray -channel rgb - threshold 80% +channel $2
