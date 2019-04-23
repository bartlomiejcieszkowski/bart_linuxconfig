#!/bin/bash

WORKING_DIR=~/raspberrypi/linux
NEW_KERNEL_NAME=kernel_4.19.32_custom.img

CURRENT_TIME=$(date +"%m_%d_%Y")

cd ${WORKING_DIR}

make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
read -p "Press enter to continue"
mkdir custom_kernel
rm -rf custom_kernel
mkdir custom_kernel
make -j 6 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs
read -p "Press enter to continue"
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=custom_kernel modules_install
mkdir -p custom_kernel/boot/overlays
cp arch/arm/boot/zImage custom_kernel/boot/${NEW_KERNEL_NAME}
cp arch/arm/boot/dts/*.dtb custom_kernel/boot/
cp arch/arm/boot/dts/overlays/*.dtb* custom_kernel/boot/overlays/
cp arch/arm/boot/dts/overlays/README custom_kernel/boot/overlays/

cd custom_kernel
tar -cvzf custom_kernel_${CURRENT_TIME}.tar.gz *
mv custom_kernel_${CURRENT_TIME}.tar.gz  ../
