#!/bin/bash

# This script installs the dependencies required for the Asahi Alarm Builder.
# It should be run on the host machine (Arch Linux or similar).

set -e

echo "## Installing host dependencies..."

# List of identified dependencies:
# - wget: for downloading the base image
# - libarchive: for bsdtar
# - arch-install-scripts: for pacstrap and arch-chroot
# - zip: for compressing images
# - squashfs-tools: for mksquashfs
# - grub: for grub-mkrescue and grub-mkconfig
# - libisoburn: for xorriso (required by grub-mkrescue)
# - mtools: for EFI support in grub-mkrescue
# - dosfstools: for EFI support in grub-mkrescue
# - e2fsprogs: for mkfs.ext4
# - btrfs-progs: for mkfs.btrfs and btrfs subvolumes
# - rsync: for copying files to the root image
# - zstd: for squashfs compression
# - tar: for saving and restoring base snapshots

DEPS=(
    wget
    libarchive
    arch-install-scripts
    zip
    squashfs-tools
    grub
    libisoburn
    mtools
    dosfstools
    e2fsprogs
    btrfs-progs
    rsync
    zstd
    tar
)

if [ "$(id -u)" -ne 0 ]; then
    SUDO='sudo'
fi

$SUDO pacman -S --asdeps --needed --noconfirm "${DEPS[@]}"

echo "## All dependencies installed successfully."
