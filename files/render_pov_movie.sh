#!/bin/bash

source /etc/profile
set -e
SCENE=$1
FRAME=$2

RESULTDIR=render_results_${SCENE}

mkdir ${RESULTDIR}
cd ${SCENE}
povray +V +SF${FRAME} +EF${FRAME} render_movie.ini
mv video*.png ../${RESULTDIR}
