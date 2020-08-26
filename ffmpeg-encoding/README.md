# FFMPEG encoding tools
Various tools to help with ffmpeg encoding

## encode-training.sh
Helps encode screen recordings from quick time on Mac OS X. It copies the audio directly but compresses the video using libx264 codec so it can be freely accesible on different operating systems.

```
Usage: ./encode-training.sh inputFile outputFile resolution(1080p or 720p)
```
Just specify the input file and the output file and the conversion should start. Resolution is optional and defaults to 1080p. Look inside the script if you'd like to modify any of the parameters.
