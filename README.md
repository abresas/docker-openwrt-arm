This project creates an OpenWRT base Docker image that can be run on Raspberry Pi
and other devices supported by the brcm2078 OpenWRT build target.

It can easily by adjusted to work with other architectures by changing the openwrt rootfs file being used.

It also injects qemu-arm-static to allow for running the image in non-arm computers, 
that have set up binfmt as described here: https://wiki.debian.org/Arm64Qemu.
