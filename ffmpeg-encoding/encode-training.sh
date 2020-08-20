#!/bin/bash

# This is a helper script to encode a video training such as a screen recording.
# It should produce a well compressed video size using the commong libx264 library.
# The video quality should be very good.
# Audio is copied directly.

inputFile=$1
outputFile=$2

usageString="Usage: $0 inputFile outputFile"

if [ -z $inputFile ]; then
	echo "No input file."
	echo $usageString
	exit 1
fi

if [ -z $outputFile ]; then
	echo "No output file."
	echo $usageString
	exit 1
fi

# Encode an ffmpeg video
# -crf controls the quality. Lower values = better quality. 23-28 should be good compromise
# -preset controls compression. The faster the less compression applied. Allowed values: ultrafast, superfast, faster, fast, medium, slow, slower etc.
# Audio is copied directly
ffmpeg -i $inputFile -vcodec libx264 -acodec copy -crf 23 -preset medium $outputFile
