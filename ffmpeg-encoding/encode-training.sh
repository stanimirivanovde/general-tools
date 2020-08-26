#!/bin/bash

# This is a helper script to encode a video training such as a screen recording.
# It should produce a well compressed video size using the commong libx264 library.
# The video quality should be very good.
# # Audio is copied directly.

inputFile=$1
outputFile=$2
resolutionString=$3

usageString="Usage: $0 inputFile outputFile resolution(1080p or 720p)"

if [ -z "$inputFile" ]; then
	echo "No input file."
	echo $usageString
	exit 1
fi

if [ -z "$outputFile" ]; then
	echo "No output file."
	echo $usageString
	exit 1
fi

if [ -z "$resolutionString" ]; then
	resolution="1080p"
fi

if [ "${resolutionString}" != "1080p" ] && [ "${resolutionString}" != "720p" ]; then
	echo "Bad resolution."
	echo $usageString
	exit 1
fi

# Default to 720p
width=1280
if [ "${resolutionString}" == "1080p" ]; then
	width=1920
fi

# Encode an ffmpeg video
# -crf controls the quality. Lower values = better quality. 23-28 should be good compromise
# -preset controls compression. The faster the less compression applied. Allowed values: ultrafast, superfast, faster, fast, medium, slow, slower, veryslow etc.
# Audio is aac with 128k bitrate
# Video is scaled to 1080p with 1920 width and calculated height based on the original resolution
ffmpeg -i "$inputFile" -vcodec libx264 -c:a aac -b:a 128k -vf "scale=${width}:-2" -crf 23 -preset medium "$outputFile"
