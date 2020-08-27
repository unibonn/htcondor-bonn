#!/bin/bash

source /etc/profile
set -e
SCENE=$1

cd ${SCENE}
povray +V render_hq.ini
mv ${SCENE}.png ..
