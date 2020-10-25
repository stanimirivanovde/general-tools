# FFMPEG encoding tools
Various tools to help with ffmpeg encoding

## encode-training.sh
Helps encode screen recordings from quick time on Mac OS X. It copies the audio directly but compresses the video using libx264 codec so it can be freely accesible on different operating systems.

```
Usage: ./encode-training.sh inputFile outputFile
```
Just specify the input file and the output file and the conversion should start. Look inside the script if you'd like to modify any of the parameters.

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
