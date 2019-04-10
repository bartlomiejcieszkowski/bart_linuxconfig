#!/bin/bash

WORKING_DIR=~/raspberrypi/linux
NEW_KERNEL_NAME=kernel_4.19.32_custom.img

cd ${WORKING_DIR}
mkdir custom_kernel
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=custom_kernel modules_install
mkdir -p custom_kernel/boot/overlays
cp arch/arm/boot/zImage custom_kernel/boot/${NEW_KERNEL_NAME}
cp arch/arm/boot/dts/*.dtb custom_kernel/boot/
cp arch/arm/boot/dts/overlays/*.dtb* custom_kernel/boot/overlays/
cp arch/arm/boot/dts/overlays/README custom_kernel/boot/overlays/

cd custom_kernel
tar -cvzf custom_kernel.tar.gz ./*
