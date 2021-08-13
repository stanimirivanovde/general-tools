#!/bin/bash

# This is a helper script to encode a video trainings such as a screen recording.
# It should produce a well compressed video size using the commong libx264 library.
# The video quality should be very good. Audio is 128kb.

inputFile=$1
outputFile=$2
resolutionString=$3

usageString="Usage: $0 inputFile outputFile resolution(optional: 1080p or 720p. Default width 1600px)"

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

# Default to 1600 - crisper text on a 15" Mac
width=1600
if [ -z "$resolutionString" ]; then
	width=1600
elif [ "${resolutionString}" != "1080p" ] && [ "${resolutionString}" != "720p" ]; then
	echo "Bad resolution."
	echo $usageString
	exit 1
elif [ "${resolutionString}" == "1080p" ]; then
	width=1920
elif [ "${resolutionString}" == "720p" ]; then
	width=1280
fi

# Pre-testing your settings
# Encode a random section instead of the whole video with the -ss and -t/-to options to quickly get a general idea of what the output will look like.
#  -ss: Offset time from beginning. Value can be in seconds or HH:MM:SS format.
#  -t: Duration. Value can be in seconds or HH:MM:SS format.
#  -to: Stop writing the output at specified position. Value can be in seconds or HH:MM:SS format.

# Encode an ffmpeg video
# -vcodec uses x264 codec. For reference of all the options check: https://trac.ffmpeg.org/wiki/Encode/H.264
# -r 24 sets the frame rate at 24 frames per second. We don't really need more than that for a screen cast.
# -threads 0 will use all the available CPU cores
# Audio is mp3 with 128k bitrate
# scale is controlled by the width with automatic height calculation
# -crf controls the quality. Lower values = better quality. 23-28 should be good compromise.
#    The range of the CRF scale is 0–51, where 0 is lossless, 23 is the default, and 51 is worst quality possible.
#    A lower value generally leads to higher quality, and a subjectively sane range is 17–28. Consider 17 or 18 to be
#    visually lossless or nearly so; it should look the same or nearly the same as the input but it isn't technically lossless.
#    Choose the highest CRF value that still provides an acceptable quality. If the output looks good, then try a higher value.
#    If it looks bad, choose a lower value.
# -preset controls compression. The faster the less compression applied. Allowed values: ultrafast, superfast, faster, fast, medium, slow, slower, veryslow etc.
#    Go with the slowest preset you can tolerate. -veryslow is the slowest usable that gives the best quality for compression.
# -tune controls extra tunning parameters. Valid values are: film, animation, grain, stillimage, fastdecode, zerolatency

# File Size Considerations
#    Go with higher crf settings and lower resolution (width) in order to decrease the size.
#    Currently the size is optimized to be less than 350MB for 1h 30min video.

command="ffmpeg -i '$inputFile' -vcodec libx265 -threads 0 -g 60 -crf 36 -c:a aac -b:a 128k -vf 'scale=${width}:-2,fps=24' -preset slow -f mp4 '$outputFile'"

echo "Running ffmpeg encoding:"
echo $command
echo "..."
eval $command
