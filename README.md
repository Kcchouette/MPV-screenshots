# MPV-screenshots
a bash script to take screenshot using mpv

## To use it:

1. Have mpv installed: `sudo apt-get install mpv`
2. Clone this repo: `git clone https://github.com/Kcchouette/MPV-screenshots.git`
3. Run it: `sh mpv-screenshots.sh`
4. Be careful, screenshots go in the directory of where you run the script

## Master vs branch v1.x

We have 2 branchs, a master, the one where we developp (and for now the `v2.x` branch) and the `v1.x` branch.

The difference is the v1.x:

 - use time and percent
 - can be run with `mpv-screenshots.sh FILE NUM_SCREENSHOTS` (NUM_SCREENSHOTS is optionnal)

The master/v2.x:

 - use frames
 - can be run with `mpv-screenshots.sh -f FILE -s THE_FIRST_FRAME_TO_BE_SCREEN -i INTERVAL_BEFORE_NEXT_SCREEN -n NUM_SCREENSHOTS -v DEBUG(True/False)`
    - where `-i INTERVAL_BEFORE_NEXT_SCREEN` and `-v DEBUG(True/False)` are optionnal

## Based on:
http://askubuntu.com/a/685735 (thanks!)
