video_file=$1
audio_file=$2

echo "------------------------------"
echo "Replace the audio track of a video."
echo "The audio file will be copied directly."
echo "------------------------------"
echo ""

if [ -z $video_file ]; then
	echo "No video file specified"
	echo "Usage: $0 VIDEO_FILE AUDIO_FILE"
	exit 1
fi
if [ -z $audio_file ]; then
	echo "No audio file specified"
	echo "Usage: $0 VIDEO_FILE AUDIO_FILE"
	exit 1
fi
ffmpeg -i "$video_file" -i "$audio_file" -c:v copy -map 0:v:0 -map 1:a:0 "${video_file}-new.mp4"
