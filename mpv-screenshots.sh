#!/usr/bin/env bash

### Global variables
filename="$1"

### Error handling
if [ -z "${filename}" ]; 
then
    echo "ERROR: No video file supplied. Please enter a video file as argument."
    exit 1;
fi

NUM_OF_SCREENSHOTS=9
if [ ! -z "$2" ]; 
then
  NUM_OF_SCREENSHOTS=$2
  echo "WARNING: Overwrite default number of screenshots to ${NUM_OF_SCREENSHOTS}."
  sleep 3s
fi

# Get the total length of the video in seconds.
#  Use mplayer to display the info of the video and then get the value of ID_LENGTH, the total number of seconds of the video.
total_length=$(sh mpv_identify.sh -frames 0 -vc null -vo null -ao null "$filename"  | grep length | sed 's/length=//' | sed 's/\..*//')
# Reference https://github.com/mpv-player/mpv/blob/master/TOOLS/mpv_identify.sh

# Remove 4 seconds from the video so that it doesn't take screenshot at the ends.

let total_length-=4

# time_slice: At which time interval should mplayer take screenshots.
let time_slice=${total_length}/${NUM_OF_SCREENSHOTS}

# time_at: When should mplayer take screenshots.
time_at=${time_slice};

# Looping to take screenshots.
for ((i=1; i <= NUM_OF_SCREENSHOTS ; i++))
do

  # Take the screenshot.
  #mplayer -loop 1 -nosound -frames 1 -ss ${time_at} -vo png:z=9 ${filename}
  mpv --really-quiet --no-audio --vo=image --start=${time_at} --frames=1 "$filename" 
  name="${filename%.*}_${time_at}.jpg"
  mv 00000001.jpg "$name"

  # Increment to the next time slice.
  let time_at+=${time_slice}

done

exit 0
