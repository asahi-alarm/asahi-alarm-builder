#!/bin/sh
set -e

mkdir -p "/boot/efi/EFI/BOOT"
mkdir -p "/boot/efi/m1n1"
touch "/boot/efi/.builder"

pacman --noconfirm -R linux || true
pacman --noconfirm -Syyu
pacman --noconfirm -S asahi-scripts asahi-fwextract m1n1 uboot-asahi mkinitcpio grub iwd sudo vim man networkmanager
