#!/bin/bash

set -e
set -u


if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "${USER}"

CURR_DIR="$(pwd)"
IMAGE_DIR="${CURR_DIR}/mounters/${1}_mount"

echo "~~~ Copying File System Tarball ~~~"
cp "${CURR_DIR}/fs_archive/wago_fs.tar.gz" "${CURR_DIR}/${1}.tar.gz"
chown "${USER}" "${CURR_DIR}/${1}.tar.gz"

echo "~~~ Create QEMU Image ~~~"
qemu-img create -f raw $1 1G
chmod a+rw $1


echo "~~~ Create Partition Table ~~~"
echo -e "o\nn\np\n1\n\n\nw" | /sbin/fdisk $1

echo "~~~ Mounting Image"
MOUNT_POINT=$(echo "/dev/mapper/$(echo "$(sudo kpartx -a -s -v $1)" | cut -d ' ' -f 3)")
sleep 1

echo "~~~ Build File System"
mkfs.ext3 "${MOUNT_POINT}"
sync

echo "~~~ Create Image Mounting Directory ~~~"
if [ ! -e "${IMAGE_DIR}" ]; then
    mkdir -p "${IMAGE_DIR}"
    chown "${USER}" "${IMAGE_DIR}"
fi

echo "~~~ Mounting QEMU Image ~~~"
mount "${MOUNT_POINT}" "${IMAGE_DIR}"

echo "~~~ Extract File System ~~~"
tar -xf "$1.tar.gz" -C "${IMAGE_DIR}"
rm "${CURR_DIR}/${1}.tar.gz"

echo "~~~ Creating Auxiliary Directories ~~~"
mkdir "${IMAGE_DIR}/aux/"
mkdir "${IMAGE_DIR}/aux/libnvram/"
mkdir "${IMAGE_DIR}/aux/libnvram.override"

echo "~~~ Patching File System ~~~"
cp $(which busybox) "${IMAGE_DIR}"
cp "${CURR_DIR}/util/fixImage.sh" "${IMAGE_DIR}"
chroot "${IMAGE_DIR}" /busybox ash /fixImage.sh
rm "${IMAGE_DIR}/fixImage.sh"
rm "${IMAGE_DIR}/busybox"

echo "~~~ Set Up Comms ~~~"
cp "${CURR_DIR}/binaries/console" "${IMAGE_DIR}/aux/console"
chmod a+x "${IMAGE_DIR}/aux/console"
mknod -m 666 "${IMAGE_DIR}/aux/ttyS1" c 4 65

cp "${CURR_DIR}/binaries/libnvram.so" "${IMAGE_DIR}/aux/libnvram.so"
chmod a+x "${IMAGE_DIR}/aux/libnvram.so"

cp "${CURR_DIR}/binaries/afl-fuzz" "${IMAGE_DIR}/afl-fuzz"
chmod a+x "${IMAGE_DIR}/afl-fuzz"

cp "${CURR_DIR}/binaries/fuzzscript" "${IMAGE_DIR}/fuzzscript"
chmod a+x "${IMAGE_DIR}/fuzzscript"

cp "${CURR_DIR}/binaries/hello" "${IMAGE_DIR}/hello"
chmod a+x "${IMAGE_DIR}/hello"

cp "${CURR_DIR}/util/preInit.sh" "${IMAGE_DIR}/aux/preInit.sh"
chmod a+x "${IMAGE_DIR}/aux/preInit.sh"

sed -i 's/exit 0/\/bin\/login/g' ${IMAGE_DIR}/etc/init.d/finalize_root 

echo "~~~ Unmounting QEMU Image ~~~"
echo $1 ${MOUNT_POINT}
sync
umount "${MOUNT_POINT}"
kpartx -d "$1"
losetup -d "${MOUNT_POINT}" &>/dev/null
dmsetup remove $(basename "$MOUNT_POINT") &>/dev/null

