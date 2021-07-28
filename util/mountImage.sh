#!/bin/bash

set -e 
set -u

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


MOUNT_DIR="mounters/${1}_mount"

echo "~~~ Creating /dev File ~~~"
MOUNT_POINT=$(echo "/dev/mapper/$(echo "$(sudo kpartx -a -s -v $1)" | cut -d ' ' -f 3)")
sleep 1



echo "~~~ Creating Mounting Directory ~~~"
if [ ! -e "${MOUNT_DIR}" ]
then
	mkdir "${MOUNT_DIR}"
fi

echo "~~~ Mounting Image ~~~"
mount "${MOUNT_POINT}" "${MOUNT_DIR}"

