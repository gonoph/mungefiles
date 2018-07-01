#!/bin/bash

myself=$0

mungeit() {
	MD5=$(which md5sum)
	MD5=${MD5:-$(which md5)}
	OF="$@"
	NF=$($MD5 <<< "$OF")
	set $NF
	NF=$1
	D1=$(cut -b 1-2 <<< "$NF")
	D2=$(cut -b 3-4 <<< "$NF")
	DIR=$(dirname "$OF")
	echo "C:mkdir -p \"$DEST/$D1/$D2\""
	echo "C:mv -v \"$OF\" \"$DEST/$D1/$D2/$NF\""
	echo "D:mkdir -p \"$DEST/$DIR\""
	echo "D:mv -v \"$DEST/$D1/$D2/$NF\" \"$OF\""
}

dofind() {
	export DEST=$(dirname "$@")
	export ENV_SWITCH=1
	find "$@" -type f -print0 | xargs -0 -n 1 $myself
}

if [ "x$ENV_SWITCH" = x ] ; then
	dofind "$@"
else
	mungeit "$@"
fi
