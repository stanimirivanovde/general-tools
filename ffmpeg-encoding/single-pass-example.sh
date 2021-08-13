inputFile="$1"
outputFile="$2"
resolution="1920:1080"

ffmpeg -i "$inputFile" -pix_fmt yuv420p -deinterlace -vf "scale=$resolution" -vsync 1 -vcodec libx264 -r 24 -threads 0 -b:v: 1024k -bufsize 1216k -maxrate 1280k -preset medium -profile:v main -tune stillimage -g 60 -x264opts no-scenecut -acodec aac -b:a 128k -ac 2 -ar 44100 -af "aresample=async=1:min_hard_comp=0.100000:first_pts=0" -f mp4 -y "$outputFile"
