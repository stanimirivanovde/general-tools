#!/bin/bash

# This is a helper script to encode a video trainings such as a screen recording.
# It should produce a well compressed video size using the commong libx264 library.
# The video quality should be very good. Audio is 128kb.

inputFile=$1
outputFile=$2

usageString="Usage: $0 inputFile outputFile"

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

# Pre-testing your settings
# Encode a random section instead of the whole video with the -ss and -t/-to options to quickly get a general idea of what the output will look like.
#  -ss: Offset time from beginning. Value can be in seconds or HH:MM:SS format.
#  -t: Duration. Value can be in seconds or HH:MM:SS format.
#  -to: Stop writing the output at specified position. Value can be in seconds or HH:MM:SS format.

# Encode an ffmpeg video
# -vcodec uses x264 codec. For reference of all the options check: https://trac.ffmpeg.org/wiki/Encode/H.264
# -crf controls the quality. Lower values = better quality. 23-28 should be good compromise. I found that 36 is good enough.
#    The range of the CRF scale is 0–51, where 0 is lossless, 23 is the default, and 51 is worst quality possible.
#    A lower value generally leads to higher quality, and a subjectively sane range is 17–28. Consider 17 or 18 to be
#    visually lossless or nearly so; it should look the same or nearly the same as the input but it isn't technically lossless.
#    Choose the highest CRF value that still provides an acceptable quality. If the output looks good, then try a higher value.
#    If it looks bad, choose a lower value.
# -vf mpdecimate will drop all duplicate frames. This is very important in order to decrease the size of a screen share. Most of the
#     frames will be duplicated since the screen is mostly static. This way we'll save on file size and speed up the encoding as well
#     while preserving the original resolution.
# -vsync vfr tells ffmpeg that we're going to have variable frame rate. This is important in order to sync the video and audio after
#     we've dropped all the duplilcate frames. For each dropped frame the video length will decrease causing the audio and video
#     to be increasingly out of sync.
# Audio is aac with 128k bitrate. Quicktime on Mac OS X doesn't like mp3 even though it results in a better file size.
# -preset controls compression. The faster the less compression applied. Allowed values: ultrafast, superfast, faster, fast, medium, slow, slower, veryslow etc.
#    Go with the slowest preset you can tolerate. -veryslow is the slowest usable that gives the best quality for compression.
# -profile controls x264 profile settings. main is used for maximum compatibility but high provides better encoding speeds and output file size.
# -tune controls extra tunning parameters. Valid values are: film, animation, grain, stillimage, fastdecode, zerolatency

command="ffmpeg -i '$inputFile' -vcodec libx264 -crf 36 -vf mpdecimate -vsync vfr -c:a aac -b:a 128k -preset veryslow -profile:v high -tune stillimage -f mp4 '$outputFile'"

echo "Running ffmpeg encoding:"
echo $command
echo "..."
eval $command
