#!/bin/bash

source /etc/profile

SCENE=$1
FRAME=$2

mkdir render_results_${SCENE}
cd ${SCENE}
povray +V +SF${FRAME} +EF${FRAME} render_movie.ini
mv video*.png ../render_results_${SCENE}/

