#!/bin/bash

source /etc/profile
set -e
SCENE=$1

cd render_results_${SCENE}
ffmpeg -r 10 -f image2 -i video%03d.png -vcodec libx264 -crf 25 -pix_fmt yuv420p -threads 4 ${SCENE}.mp4
mv ${SCENE}.mp4 ../
