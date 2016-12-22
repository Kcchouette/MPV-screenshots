#!/usr/bin/env bash

while getopts ":f:s:i:n:v" opt; do
  case $opt in
    f)
      declare -r file="$OPTARG"
      ;;
    s)
      declare -r startFrame="$OPTARG"
      ;;
    i)
      declare -r intervalScreenshots="$OPTARG"
      ;;
    n)
      declare -r numberScreenshots="$OPTARG"
      ;;
    v)
      declare -r verbose="TRUE"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Quit if we missed -f, -s or -n
if [[ -z "$file" ]] || [[ -z "$startFrame" ]] || [[ -z "$numberScreenshots" ]] ; then
  printf 'You must at the minimum set -f, -s and -n
	-f <the video file>
	-s <the number of the frame of the first screenshot>
	-i <the interval of frames of the next screenshot>
	-n <the number of screenshots you want>
	-v <TRUE or FALSE>\n'
  exit 1
fi

# Informations grabbing
declare -r filename="$(basename "${file}")"
declare -r lastFrame="$(mpv --term-playing-msg='frame=${estimated-frame-count}' --load-scripts=no --quiet --vo=null --ao=null --no-sub --no-cache --no-config --frames 1 "$file" | grep 'frame' | cut -d '=' -f2)"
declare -r fpsVideo="$(mpv --term-playing-msg='fps=${estimated-vf-fps}' --load-scripts=no --quiet --vo null --ao=null --no-sub --no-cache --no-config --frames 1 "$file" | grep 'fps' | cut -d '=' -f2)"

# Declare interval for each screenshot
if [[ -z "$intervalScreenshots" ]] ; then
  declare -r diffFrame="$(bc -l <<< "$lastFrame - $startFrame")"
  declare -r intervalFrame="$(bc -l <<< "$diffFrame / $numberScreenshots")"
else
  declare -r intervalFrame="$intervalScreenshots"
fi

# Looping to take screenshots
declare currentFrame="$startFrame"
for i in $(seq 1 "$numberScreenshots") ; do
  
  declare currentTime="$(bc -l <<< "$currentFrame / $fpsVideo")"
  
  if [[ -n "$verbose" ]] ; then
    printf 'Filename: %s\n\n' "$filename"
 
    printf 'Current time: %.2f\n\n' "$currentTime"
    
    printf 'Last frame: %s\n' "$lastFrame"
    printf 'FPS: %s\n' "$fpsVideo"
    printf 'Interval: %s\n' "$intervalFrame"
    printf 'Screenshot: %02d\n\n\n' "$i"
  fi

  # Debug line
  # mpv --really-quiet --load-scripts=no --no-audio --no-sub --frames 1 --start "$currentTime" "$file" -o "${filename%.*}_${currentTime%%0*}.png"

  mpv --really-quiet --ao=null --no-sub --frames 1 --start "$currentTime" "$file" --vo image --vo-image-format png -o "$(printf '%02d_%s.png' "$i" "${filename%.*}")"
  currentFrame="$(bc -l <<< "$currentFrame + $intervalFrame")"
done
