#!/usr/bin/env bash

### Global variables
declare -r file="$1"
declare -r filename="$(basename "$file")"

### Error handling
if [ -z "${file}" ]; 
then
    echo "ERROR: No video file supplied. Please enter a video file as argument."
    exit 1;
fi

if [ ! -z "$2" ]; 
then
  declare -ri NUM_OF_SCREENSHOTS="$2"
  echo "WARNING: Overwrite default number of screenshots to ${NUM_OF_SCREENSHOTS}."
  sleep 3s
else
  declare -ri NUM_OF_SCREENSHOTS='9'
fi

# Get the total length of the video in seconds.
declare -i total_length="$(mpv "$file" --quiet --vo null --ao null --frames 1 --term-playing-msg 'duration=${=duration}' | grep 'duration' | cut -d '=' -f2 | cut -d '.' -f1)"

# Remove 4 seconds from the video so that it doesn't take screenshot at the ends.
let total_length-='4'

# Add 1 to the div number, like that the image is not at the end of the video
# else, for 1 picture total_length/1 = total_length, so the end
# with that, it'll be total_length/2
declare -i DIV_NUMBER="${NUM_OF_SCREENSHOTS}"
let DIV_NUMBER+='1'

# time_slice: At which time interval should mpv take screenshots.
let time_slice="${total_length}/${DIV_NUMBER}"

# time_at: When should mplayer take screenshots.
time_at=${time_slice};

# Looping to take screenshots.
declare -i i
for i in $(seq 1 "$NUM_OF_SCREENSHOTS")
do

  # Take the screenshot.
  declare name="${filename%.*}_${time_at}.png"
  mpv --really-quiet --no-audio --vo=image --start=${time_at} --frames=1 "$file" -o "$name"

  # Increment to the next time slice.
  let time_at+="${time_slice}"

done

exit 0
