# This settings is important: -pix_fmt yuv420p
# Otherwise you'll get an error due to the high profile if you record the video with Quicktime
# Play with crf to reduce the size/quality
# libx264 is the most widely used codec but in order to be recognized everywhere we need to use the high video profile
ffmpeg -i ~/Desktop/stan-intro-final.mov -vcodec libx264 -crf 24 -c:a aac -b:a 128k -preset veryslow -profile:v high -pix_fmt yuv420p -f mp4 ~/Desktop/stan-intro-final.mp4
