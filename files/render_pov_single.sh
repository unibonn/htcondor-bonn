#!/bin/bash

source /etc/profile

SCENE=$1

cd ${SCENE}
povray +V render.ini
mv ${SCENE}.png ..
