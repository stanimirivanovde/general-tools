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
# -crf controls the quality. Lower values = better quality. 23-28 should be good compromise. I found that 32 is good enough.
#    The range of the CRF scale is 0–51, where 0 is lossless, 23 is the default, and 51 is worst quality possible.
#    A lower value generally leads to higher quality, and a subjectively sane range is 17–28. Consider 17 or 18 to be
#    visually lossless or nearly so; it should look the same or nearly the same as the input but it isn't technically lossless.
#    Choose the highest CRF value that still provides an acceptable quality. If the output looks good, then try a higher value.
#    If it looks bad, choose a lower value.
# scale is controlled by the width with automatic height calculation
# use 5 fps. Normally a screen recording might use ~ 60 fps which is too much. This will improve the encoding speed and the final file size.
# Audio is aac with 128k bitrate. Quicktime on Mac OS X doesn't like mp3 even though it results in a better file size.
# -preset controls compression. The faster the less compression applied. Allowed values: ultrafast, superfast, faster, fast, medium, slow, slower, veryslow etc.
#    Go with the slowest preset you can tolerate. -veryslow is the slowest usable that gives the best quality for compression.
# -profile controls x264 profile settings. main is used for maximum compatibility but high provides better encoding speeds and output file size.
# -tune controls extra tunning parameters. Valid values are: film, animation, grain, stillimage, fastdecode, zerolatency

# File Size Considerations
#    Go with higher crf settings and lower resolution (width) in order to decrease the size.
#    Currently the size is optimized to be less than 350MB for 1h 30min video.

command="ffmpeg -i '$inputFile' -vcodec "libx264" -crf 32 -vf 'scale=${width}:-2,fps=5' -c:a aac -b:a 128k -preset veryslow -profile:v high -tune stillimage -f mp4 '$outputFile'"

echo "Running ffmpeg encoding:"
echo $command
echo "..."
eval $command
