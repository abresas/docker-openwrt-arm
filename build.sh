#!/bin/bash

set -e
set -o pipefail

if [ "$(id -u)" != "0" ]; then
	echo "This script must be run as root, to be able to mount." 1>&2
	exit 1
fi

OPENWRT_IMG_URL=https://downloads.openwrt.org/barrier_breaker/14.07/brcm2708/generic/openwrt-brcm2708-ext4.img
DOCKER_REPO=abresas/openwrt-arm-test
MOUNT_POINT=/mnt/openwrt
QEMU_ARM_STATIC=./qemu-arm-static

# Download rootfs image from OpenWRT
echo "Downloading OpenWRT image rootfs... "
curl -q "$OPENWRT_IMG_URL" -o openwrt-ext4.img

echo "Mounting rootfs to $MOUNT_POINT... "
mkdir -p "$MOUNT_POINT"
mount openwrt-ext4.img "$MOUNT_POINT"
echo -n "OK"

echo "Injecting qemu-arm-static... "
cp "$QEMU_ARM_STATIC" "$MOUNT_POINT/usr/bin"
echo -n "OK"

# Create a tarball
echo -n "Creating image tarball... "
tar -C /mnt/openwrt --numeric-owner --exclude=/proc --exclude=/sys -cvf openwrt.tar .
echo "OK"

# Import to docker
echo "Importing to docker... "
cat openwrt.tar | docker import - $DOCKER_REPO

echo "Cleaning up... "
umount $MOUNT_POINT
rm openwrt.tar openwrt-ext4.img

echo "Done."
