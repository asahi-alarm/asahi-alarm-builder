#!/bin/sh
set -e

mkdir -p "/boot/efi/EFI/BOOT"
mkdir -p "/boot/efi/m1n1"
touch "/boot/efi/.builder"

pacman --noconfirm -R linux-aarch64
pacman --noconfirm -Syu

PACKAGES="asahi-scripts asahi-fwextract m1n1 uboot-asahi mkinitcpio grub iwd sudo vim man networkmanager noto-fonts noto-fonts-cjk noto-fonts-emoji btrfs-progs"

pacman --noconfirm -S $PACKAGES
