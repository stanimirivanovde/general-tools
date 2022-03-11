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

hdrParams=$(./list-hdr-info-from-source-video.sh $source)

echo "Using HDR params: $hdrParams"

options=""
if [ "$conversion" == "1" ]; then
	# A movie is X frames per second. For example 23 frames per second. The encoding time depends on how many frames a second we can get from our PC.
	# Slow is very slow: 3.1 frames a second meaning it will take 7.5 seconds to encode 1 movie second since 7.5 * 3.1 = 24 frames which is a movie second (if the movie is 23 frames per second).
	# So the actual encoding time would be 7.5 time the number of movie seconds. For 1 hours movie this is 7.5 hours to finish the encoding.
	# Faster is better: 11 frames a second meaning 2.1 seconds to encode a movie second. This will take 2.1 hours to finish encoding a 1 hour movie. A little bit better.
	options="-c:v libx265 -crf 21 -preset veryfast -profile:v main10 $hdrParams"
elif [ "$conversion" == "2" ]; then
	options="-c:v hevc_videotoolbox -profile:v main10 -tag:v hvc1 -pix_fmt:v yuv420p10le -b:v 8000k -color_primaries:v bt2020 -color_trc:v smpte2084 -colorspace:v bt2020nc"
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
#~/code/ffmpeg/ffmpeg -hide_banner \
/usr/local/opt/ffmpeg/bin/ffmpeg -hide_banner \
	-i "$source" \
	-map_chapters 0 \
	-metadata title="$movieName" \
	-map 0:0 \
	-map 0:2 -c:a copy \
	${options} \
	"$dest"
