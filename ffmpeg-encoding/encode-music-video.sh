#!/bin/bash

# This script converts a video produced by iMovie or another video app to a smaller size but preserving the general quality of the video.
# The quality is controlled by the -crf argument. The higher the value the lower the quality

function print_help {
	app_name=$1
	echo "Usage: $app_name SOURCE_VIDEO DESTINATION_VIDEO"
	echo ""
	echo "Description:"
	echo "Converts a video produced by iMovie or another video app to a smaller size but preserving the general quality of the video."
	exit 1
}

source=$1
destination=$2
if [ -z $source ]; then
	echo "Missing source video"
	print_help $0
fi

if [ -z $destination ]; then
	echo "Missing desitnation video"
	print_help $0
fi

set -x
ffmpeg -i $source -vcodec libx264 -crf 24 -c:a copy -preset veryslow -profile:v high -pix_fmt yuv420p -f mp4 $destination
