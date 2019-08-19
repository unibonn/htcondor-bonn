#!/bin/bash

source /etc/profile

SCENE=$1

cd ${SCENE}
povray +V +SF${FRAME} +EF${FRAME} render.ini
mv ${SCENE}.png ..
