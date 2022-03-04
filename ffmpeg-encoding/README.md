# FFMPEG encoding tools
Various tools to help with ffmpeg encoding

## encode-screen-recording.sh
Helps encode screen recordings from quick time on Mac OS X. It copies the audio directly but compresses the video using libx264 codec so it can be freely accesible on different operating systems.

```
Usage: ./encode-screen-recording.sh inputFile outputFile
```
Just specify the input file and the output file and the conversion should start. Look inside the script if you'd like to modify any of the parameters.

## list-hdr-info-from-source-video.sh
This is a convinient script to extract the relevant HDR parameters from a source video so you can convert it successfully. It uses ffprobe's JSON output and parses the arguments. It constructs an -x265-params that can be passed directly to ffmpeg. You can paste it in ffmpeg-hdr-encode.sh file to get this working

```
list-hdr-info-from-source-video.sh SOURCE_VIDEO
```

## list-all-av-streams.sh
This lists all Streams and their IDs from the source video. You can use it to discovery all streams and their IDs so you can correctly map it if needed. You can preserve only the streams you care about such as the main video stream and one of the audio streams. For Plex' Direct Streaming to work it gets picky with some of the subtitle streams. If they are removed then the file plays correctly. In order to save only particular streams in a converted video you can use this

```
ffmpeg -i $i -map 0:0 -map 0:1 -codec copy $i.mkv
```

This will select stream 0 (video) and stream 1 (audio) and put it in an mkv file.

## ffmpeg-hdr-encdoe.sh
Encodes a video preserving HDR contents and using libx265, hardware accelerated videotoolbox on Mac or direct copy. You need to modify the script to setup the stream mappings. The mapping IDs
can be retrieved from ffmpeg itself:

```
ffmpeg -i SOURCE_VIDEO 2>&1 | less
```

Once you chose the mappings to keep you can update the script and change the -map:0:1/2/3..n options. And then run the conversion as such:

```
ffmpeg-hdr-encode.sh SOURCE_VIDEO DESTINATION_VIDEO 1/2/3
```

Where the last parameters mean:
1. Convert using libx265 (best quality and smallest file size but slowest to execute)
2. Convert using hardware accelerated videotoolbox on Mac OS X (faster but less customizations and worse quality than 1)
3. Copy the streams directly (best quality and fastest but largest file)

## Quality Parameters
**-vcodec libx264**
For reference of all the options check: https://trac.ffmpeg.org/wiki/Encode/H.264

**-crf 36**
Controls the quality. Lower values = better quality. 23-28 should be good compromise. I found that 36 is good enough. The range of the CRF scale is 0–51, where 0 is lossless, 23 is the default, and 51 is worst quality possible.
A lower value generally leads to higher quality, and a subjectively sane range is 17–28. Consider 17 or 18 to be visually lossless or nearly so; it should look the same or nearly the same as the input but it isn't technically lossless.

Choose the highest CRF value that still provides an acceptable quality. If the output looks good, then try a higher value. If it looks bad, choose a lower value.

**-vf mpdecimate**
This will drop all duplicate frames. This is very important in order to decrease the size of a screen share. Most of the
frames will be duplicated since the screen is mostly static. This way we'll save on file size and speed up the encoding as well
while preserving the original resolution.

**-vsync vfr**
This tells ffmpeg that we're going to have variable frame rate. This is important in order to sync the video and audio after we've dropped all the duplilcate frames. For each dropped frame the video length will decrease causing the audio and video to be increasingly out of sync.

**Audio is aac with 128k bitrate**
Quicktime on Mac OS X doesn't like mp3 even though it results in a better file size.

**-preset**
This controls compression. The faster the less compression applied. Allowed values: ultrafast, superfast, faster, fast, medium, slow, slower, veryslow etc. Go with the slowest preset you can tolerate. -veryslow is the slowest usable that gives the best quality for compression.

**-profile**
This controls x264 profile settings. main is used for maximum compatibility but high provides better encoding speeds and output file size.

**-tune**
This controls extra tunning parameters. Valid values are: film, animation, grain, stillimage, fastdecode, zerolatency
