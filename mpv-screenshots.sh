#!/usr/bin/env bash

### Global variables
declare -r file="$1"
declare -r filename="$(basename "${file}")"

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

# Define begin percentage
# 1 screen  -> 50/100                 = 100 / 2
# 2 screens -> 33/100 67/100          = 100 / 3
# 3 screens -> 25/100 50/100 75/100   = 100 / 4
# ...
declare startPercent="$((100/$((${NUM_OF_SCREENSHOTS}+1))))"

# Looping to take screenshots.
declare -i i
for i in $(seq 1 "${NUM_OF_SCREENSHOTS}")
do

  # Take the screenshot.
  declare currentPercent="$((${startPercent}*$i))"
  declare name="${filename%.*}_${currentPercent}_percent.png"
  mpv --really-quiet --no-audio --no-sub --start="${currentPercent}%" --frames=1 "${file}" -o "${name}"

done

exit 0
