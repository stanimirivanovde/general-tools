#!/bin/bash

source=$1
dest=$2

if [ -z $source ]; then
	echo "No source specified"
	exit 1
fi

if [ -z $dest ]; then
	echo "No destination specified"
	exit 1
fi

ffmpeg -i "$source" -pix_fmt rgb24 -s 1980x1080 -vf mpdecimate -vsync vfr -r 10 -f gif - | gifsicle --optimize=3 --delay=15 > "$dest"
