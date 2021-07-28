#/bin/bash

set -e
set -u

DEVICE=$(sudo echo "/dev/mapper/$(echo "$(sudo kpartx -a -s -v $1)" | cut -d ' ' -f 3)") #$(echo "/dev/mapper/$(echo "$(sudo kpartx -a -s -v $1)" | cut -d ' ' -f 3)")
CURR_DIR="$(pwd)"
IMAGE_DIR="${CURR_DIR}/mounters/${1}_mount"
sleep 1
sync

echo "~~~ Unmounting Image ~~~"
umount ${DEVICE}

echo "~~~ Cleaning Up ~~~"
losetup -d ${DEVICE} &>/dev/null
sleep 1
dmsetup remove $(basename ${DEVICE}) &>/dev/null
sleep 1
kpartx -d $1
sleep 1

rm -r $IMAGE_DIR
