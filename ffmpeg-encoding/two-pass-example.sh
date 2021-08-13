inputFile=$1
outputFile=$2

duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$inputFile")
# Size in megabytes per hour
sizePerHour=100
totalFileSize=$(echo "$duration / 3600 * $sizePerHour" | bc -l )
audioBitrate=128
videoBitrate=$(echo "$totalFileSize * 8192 / $duration - $audioBitrate" | bc -l)
# Cast to an integer
let videoBitrate=${videoBitrate%.*}

echo "Input file: $inputFile"
echo "Output file: $outputFile"
echo "Duration: $duration"
echo "Size per hour: $sizePerHour"
echo "Total file size: $totalFileSize"
echo "Video bitrate: $videoBitrate"
echo "Audio bitrate: $audioBitrate"

command="ffmpeg -y -i "$inputFile" -c:v libx264 -b:v "${videoBitrate}k" -vf 'scale=1600:-2,fps=24' -pass 1 -g 60 -x264opts no-scenecut -vsync 1 -preset veryslow -tune stillimage -threads 0"

# Two pass encoding requires identical parameters minus the audio codec and the output file
eval "$command -an -f null /dev/null" && eval "$command -c:a aac -b:a "${audioBitrate}k" -f mp4 "$outputFile"
