#!/bin/bash

# This was taken from the website: https://codecalamity.com/encoding-uhd-4k-hdr10-videos-with-ffmpeg/

json=$(ffprobe -hide_banner -loglevel warning -select_streams v -print_format json -show_frames -read_intervals "%+#1" -show_entries "frame=color_space,color_primaries,color_transfer,side_data_list,pix_fmt" -i "$1" | jq .frames)

echo $json | >&2 jq

pix_fmt=$(echo $json | jq  -r '.[].pix_fmt')
color_space=$(echo $json | jq  -r '.[].color_space')
color_primaries=$(echo $json | jq  -r '.[].color_primaries')
color_transfer=$(echo $json | jq  -r '.[].color_transfer')

red_x=$(echo $json | jq  '.[].side_data_list' | jq -r '.[0].red_x' | cut -d'/' -f 1)
red_y=$(echo $json | jq  '.[].side_data_list' | jq -r '.[0].red_y' | cut -d'/' -f 1)
green_x=$(echo $json | jq  '.[].side_data_list' | jq -r '.[0].green_x' | cut -d'/' -f 1)
green_y=$(echo $json | jq  '.[].side_data_list' | jq -r '.[0].green_y' | cut -d'/' -f 1)
blue_x=$(echo $json | jq  '.[].side_data_list' | jq -r '.[0].blue_x' | cut -d'/' -f 1)
blue_y=$(echo $json | jq  '.[].side_data_list' | jq -r '.[0].blue_y' | cut -d'/' -f 1)
white_point_x=$(echo $json | jq  '.[].side_data_list' | jq -r '.[0].white_point_x' | cut -d'/' -f 1)
white_point_y=$(echo $json | jq  '.[].side_data_list' | jq -r '.[0].white_point_y' | cut -d'/' -f 1)
min_luminance=$(echo $json | jq  '.[].side_data_list' | jq -r '.[0].min_luminance' | cut -d'/' -f 1)
max_luminance=$(echo $json | jq  '.[].side_data_list' | jq -r '.[0].max_luminance' | cut -d'/' -f 1)
max_content=$(echo $json | jq  '.[].side_data_list' | jq -r '.[1].max_content' | cut -d'/' -f 1)
max_average=$(echo $json | jq  '.[].side_data_list' | jq -r '.[1].max_average' | cut -d'/' -f 1)

>&2 echo "pix_fmt: $pix_fmt"
>&2 echo "color_space: $color_space"
>&2 echo "color_primaries: $color_primaries"
>&2 echo "color_transfer: $color_transfer"
>&2 echo "red_x $red_x"
>&2 echo "red_y $red_y"
>&2 echo "green_x $green_x"
>&2 echo "green_y $green_y"
>&2 echo "blue_x $blue_x"
>&2 echo "blue_y $blue_y"
>&2 echo "min_luminance $min_luminance"
>&2 echo "max_luminance $max_luminance"
>&2 echo "max_content $max_content"
>&2 echo "max_average $max_average"
>&2 echo ""
>&2 echo "Use these x265 params:"

# hdr-opt=1 we are telling it yes, we will be using HDR
# repeat-headers=1we want these headers on every frame as required
# colorprim, transfer and colormatrix the same as ffprobe listed
# master-display this is where we add our color string from above
# max-cll Content light level data, in our case 0,0 (max_content,max_average)
# asm=avx512 can lead to better performance on gen 10+ processors
echo "-pix_fmt $pix_fmt -x265-params hdr-opt=1:repeat-headers=1:colorprim=$color_primaries:transfer=$color_transfer:colormatrix=$color_space:master-display=G($green_x,$green_y)B($blue_x,$blue_y)R($red_x,$red_y)WP($white_point_x,$white_point_y)L($max_luminance,$min_luminance):max-cll=$max_content,$max_average:asm=avx512"
