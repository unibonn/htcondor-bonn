#!/bin/bash
source /etc/profile

echo "Called with arguments:"
echo "$@"

echo "PATH variable:"
echo $PATH

echo "OS release:"
cat /etc/os-release

echo "Running in Condor Slot:"
echo ${_CONDOR_SLOT_NAME}

echo "Kernel version:"
uname -a

echo "Full environment:"
env

echo "Running processes:"
ps faux
