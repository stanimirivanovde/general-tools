#!/bin/bash
set -x
source="$1"
dest="$2"
# 1 means hvec x265 conversion
# 2 means hardware accelerated conversion
# 3 means copy without conversion
conversion="$3"

movieName=$(basename "$source" .mkv)
echo "Converting $movieName"
echo "Mode $conversion"

options=""
if [ "$conversion" == "1" ]; then
	# hdr-opt=1 we are telling it yes, we will be using HDR
    # repeat-headers=1we want these headers on every frame as required
    # colorprim, transfer and colormatrix the same as ffprobe listed
    # master-display this is where we add our color string from above
    # max-cll Content light level data, in our case 0,0
	options="-c:v libx265 -crf 28 -preset superfast -pix_fmt yuv420p10le -x265-params keyint=60:bframes=3:vbv-bufsize=75000:vbv-maxrate=75000:hdr-opt=1:repeat-headers=1:colorprim=bt2020:transfer=smpte2084:colormatrix=bt2020nc:master-display=G(13250,34500)B(7500,3000)R(34000,16000)WP(15635,16450)L(40000000,50):max-cll=999,100:profile=main10"
elif [ "$conversion" == "2" ]; then
	options="-c:v hevc_videotoolbox -profile:v main10 -tag:v hvc1 -pix_fmt yuv420p10le "
elif [ "$conversion" == "3" ]; then
	options="-c:v copy -pix_fmt yuv420p10le "
else
	echo "Invalid third parameter: $conversion. Please specify 1 (libx265 conversion), 2 (videotoolbox hw accel conversion), 3 (copy)"
	echo "Usage: ffmpeg-hdr-encode SOURCE_FILE DEST_FILE CONVERSION_TYPE"
	exit 1
fi

if [ -z "$options" ]; then
	echo "Invalid options."
	exit 1
fi

# Add this to limit the conversion to 10 minutes. You probably want something shorter because hvec x265 takes forever to encode
#-ss 00:10:00 -t 00:10:00 \

# The map tells ffmpeg which stream to process the first number is 0 for copy, the second is the stream ID. You can see it with ffmpeg -i.
#-map 0:3 -c:s copy \
#-map 0:2 -c:a aac -ac 2 \
/usr/local/opt/ffmpeg/bin/ffmpeg -hide_banner \
	-i "$source" \
	-analyzeduration 20000000 -probesize 20000000 \
	-ss 00:00:00 -t 00:01:00 \
	-map_chapters 0 \
	-metadata title="$movieName" \
	-map 0:0 \
	-map 0:2 -c:a copy \
	${options} \
	"$dest"
