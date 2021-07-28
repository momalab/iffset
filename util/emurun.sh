#!/bin/bash

set -u

CURR_DIR=$(pwd)


function cleanup {
    pkill -P $$
    
}


trap cleanup EXIT

echo "Start QEMU emulation... Press Ctrl-A +X to exit"
sleep 1s

QEMU_AUDIO_DRV=none qemu-system-arm -m 256 -M virt -kernel "${CURR_DIR}/binaries/zImage.koko" \
    -drive if=none,file="${CURR_DIR}/$1",format=raw,id=rootfs -device virtio-blk-device,drive=rootfs -append "root=/dev/vda1 console=ttyS0 nandsim.parts=64,64,64,64,64,64,64,64,64,64 rdinit=/aux/preInit.sh rw debug ignore_loglevel print-fatal-signals=1 firmadyne.syscall=0"\
    -nographic \
    -device virtio-net-device,netdev=net0 -netdev socket,id=net0,listen=:2000 -device virtio-net-device,netdev=net1 -netdev socket,id=net1,listen=:2001 -device virtio-net-device,netdev=net2 -netdev socket,id=net2,listen=:2002 -device virtio-net-device,netdev=net3 -netdev socket,id=net3,listen=:2003 | tee qemu.final.serial.log
