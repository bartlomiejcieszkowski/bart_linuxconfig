#!/bin/bash
set -x
J_OPTIMAL=$(nproc)
J_OPTIMAL=$((${J_OPTIMAL}+(${J_OPTIMAL}/2)))
# optimal -j is 1.5*processors number
#WORKING_DIR=~/dv/personal/backup/raspberrypi/linux

CURRENT_TIME=$(date +"%m_%d_%Y")
NEW_KERNEL_NAME=kernel_custom.img

usage() { echo "Usage: $0 [-a <arm|arm64>] [-p <pi1|pi2|pi3|pi4>]" 1>&2; exit 1; }

while getopts ":a:p:" o; do
	case "${o}" in
		a)
			a=${OPTARG}
			((a == arm || a == arm64)) || usage
			;;
		p)
			p=${OPTARG}
			((p == pi1 || p == pi2 || p == pi3 || p == pi4 )) || usage
			;;
		*)
			usage
			;;
	esac
done
shift $((OPTIND-1))

if [ -z "${a}" ] || [ -z "${p}" ]; then
	usage
fi


if [[ ${a} == arm ]]; then
	ARCH=arm
	CROSS_COMPILE=arm-linux-gnueabihf-
elif [[ ${a} == arm64 ]]; then
	ARCH=arm64
	CROSS_COMPILE=aarch64-linux-gnu-
fi

if [[ ${p} == pi1 ]]; then
	KERNEL=kernel
	DEFCONFIG=bcmrpi_defconfig
elif [[ ${p} == pi2 ]]; then
	KERNEL=kernel7
	DEFCONFIG=bcm2709_defconfig
elif [[ ${p} == pi3 ]]; then
	if [[ ${ARCH} == arm ]]; then
		KERNEL=kernel7l
		DEFCONFIG=bcm2709_defconfig
	else
		KERNEL=kernel8
		DEFCONFIG=bcm2711_defconfig
	fi
elif [[ ${p} == pi4 ]]; then
	if [[ ${ARCH} == arm ]]; then
		KERNEL=kernel7l
	else
		KERNEL=kernel8
	fi
	DEFCONFIG=bcm2711_defconfig
fi

if [[ ${ARCH} == arm64 ]]; then
	if [[ ${p} == pi-1 || ${p} == pi-2 ]]; then
		echo "Illegal combination"
		usage
	fi
	TARGETS="Image modules dtbs"
else
	TARGETS="zImage modules dtbs"
fi

echo "-j ${J_OPTIMAL}"
echo "ARCH=${ARCH}"
echo "KERNEL=${KERNEL}"
echo "CROSS_COMPILE=${CROSS_COMPILE}"

KERNEL_TARGET_DIR="kernel_${p}_${ARCH}"
#cd ${WORKING_DIR}

make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} menuconfig
read -p "Press enter to continue"
mkdir ${KERNEL_TARGET_DIR}
rm -rf ${KERNEL_TARGET_DIR}
mkdir ${KERNEL_TARGET_DIR}
make -j ${J_OPTIMAL} ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} ${TARGETS}
read -p "Press enter to continue"
make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} INSTALL_MOD_PATH=${KERNEL_TARGET_DIR} modules_install
mkdir -p custom_kernel/boot/overlays
cp arch/arm/boot/zImage custom_kernel/boot/${NEW_KERNEL_NAME}
cp arch/arm/boot/dts/*.dtb custom_kernel/boot/
cp arch/arm/boot/dts/overlays/*.dtb* custom_kernel/boot/overlays/
cp arch/arm/boot/dts/overlays/README custom_kernel/boot/overlays/

cd ${KERNEL_TARGET_DIR}
tar -cvzf ${KERNEL_TARGET_DIR}_${CURRENT_TIME}.tar.gz *
mv ${KERNEL_TARGET_DIR}_${CURRENT_TIME}.tar.gz  ../
