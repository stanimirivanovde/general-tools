# loop through all files in the directory listing their audio and video streams
# Those can be extracted by ffmpeg using -map 0:STREAM_ID -> this way you can extract only the streams you care about
# Some MKV files contain incompatble subtitle streams that cause Plex to not do Direct Streaming. By removing the
# incompatible streams you can fix the problem
for i in *.mkv; do echo $i; ffprobe -i $i 2>&1 | grep Video; ffprobe -i $i 2>&1 | grep Audio; done

# to remove incompatible streams you can select only the ones you care about like this:
# ffmpeg -i $i -map 0:0 -map 0:1 -codec copy $i.mkv
# This will select stream 0 (video) and stream 1 (audio) and put it in an mkv file
