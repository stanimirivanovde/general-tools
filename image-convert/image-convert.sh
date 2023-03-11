# Usage image-convert.sh image.HEIC
# The output will be image.HEIC.jpg
magick $1 -resize 35% -quality 80 $1.jpg
