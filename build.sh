#!/bin/sh

set -e

BASE_IMAGE_URL="https://arch-linux-repo.drzee.net/arch/tarballs/os/aarch64/archlinux-bootstrap-2025.12.01-aarch64.tar.zst"
BASE_IMAGE="$(basename "$BASE_IMAGE_URL")"

DL="$PWD/dl"
ROOT="$PWD/root"
FILES="$PWD/files"
IMAGES="$PWD/images"
IMG="$PWD/img"

EFI_UUID=2ABF-9F91
ROOT_UUID=725346d2-f127-47bc-b464-9dd46155e8d6
export ROOT_UUID EFI_UUID

if [ "$(whoami)" != "root" ]; then
	echo "You must be root to run this script."
	exit 1
fi

clean_mounts() {
	while grep -q "$ROOT/[^ ]" /proc/mounts; do
		cat /proc/mounts | grep "$ROOT" | cut -d" " -f2 | xargs umount || true
		sleep 0.1
	done
}

init() {
	clean_mounts

	umount "$IMG" 2>/dev/null || true
	mkdir -p "$DL" "$IMG"

	if [ ! -e "$DL/$BASE_IMAGE" ]; then
		echo "## Downloading base image..."
		wget -c "$BASE_IMAGE_URL" -O "$DL/$BASE_IMAGE.part"
		mv "$DL/$BASE_IMAGE.part" "$DL/$BASE_IMAGE"
	fi

	umount "$ROOT" 2>/dev/null || true
	rm -rf "$ROOT"
	mkdir -p "$ROOT"

	echo "## Unpacking base image..."
	bsdtar -xpf "$DL/$BASE_IMAGE" -C "$ROOT" -s '!^root\.aarch64/!!' root.aarch64

	cp -r "$FILES" "$ROOT"

	mount --bind "$ROOT" "$ROOT"

	cp "$ROOT"/etc/pacman.d/mirrorlist{,.orig}

	echo "## Installing keyring package..."
	pacstrap -G "$ROOT" asahi-alarm-keyring
}

run_scripts() {
	group="$1"
	echo "## Running script group: $group"
	for i in "scripts/$group/"*; do
		echo "### Running $i"
		arch-chroot "$ROOT" /bin/bash <"$i"
		# Work around some devtmpfs shenanigans... something keeps that mount in use?
		clean_mounts
	done
}

make_uefi_image() {
	imgname="$1"
	img="$IMAGES/$imgname"
	mkdir -p "$img"
	echo "## Making image $imgname"
	echo "### Creating EFI system partition tree..."
	mkdir -p "$img/esp"
	cp -r "$ROOT"/boot/efi/m1n1 "$img/esp/"
	echo "### Compressing..."
	rm -f "$img".zip
	(
		cd "$img"
		zip -r ../"$imgname".zip *
		cd ..
		rm -rf "$img"
	)
	echo "### Done"
}

make_image() {
	imgname="$1"
	img="$IMAGES/$imgname"
	mkdir -p "$img"
	echo "## Making image $imgname"
	echo "### Cleaning up..."
	rm -f "$ROOT/var/cache/pacman/pkg"/*
	echo "### Calculating image size..."
	size="$(du -B M -s "$ROOT" | cut -dM -f1)"
	echo "### Image size: $size MiB"
	size=$(($size + ($size / 8) + 64))
	echo "### Padded size: $size MiB"
	rm -f "$img/root.img"
	truncate -s "${size}M" "$img/root.img"
	echo "### Making filesystem..."
	mkfs.ext4 -O '^metadata_csum' -U "$ROOT_UUID" -L "asahi-root" "$img/root.img"
	echo "### Loop mounting..."
	mount -o loop "$img/root.img" "$IMG"
	echo "### Copying files..."
	rsync -aHAX \
		--exclude /files \
		--exclude '/tmp/*' \
		--exclude /etc/machine-id \
		--exclude '/boot/efi/*' \
		"$ROOT/" "$IMG/"
	mv -f "$IMG"/etc/pacman.d/mirrorlist{.orig,}
	echo "### Running grub-mkconfig..."
	arch-chroot "$IMG" grub-mkconfig -o /boot/grub/grub.cfg
	echo "### Unmounting..."
	umount "$IMG"
	echo "### Creating EFI system partition tree..."
	mkdir -p "$img/esp/EFI/BOOT"
	cp "$ROOT"/boot/grub/arm64-efi/core.efi "$img/esp/EFI/BOOT/BOOTAA64.EFI"
	cp -r "$ROOT"/boot/efi/m1n1 "$img/esp/"
	echo "### Compressing..."
	rm -f "$img".zip
	(
		cd "$img"
		zip -1 -r ../"$imgname".zip *
		cd ..
		rm -rf "$img"
	)
	echo "### Done"
}

init
run_scripts base
make_image "asahi-archport-base"
# run_scripts plasma
# make_image "asahi-archport-plasma"

# need to run init and base again or we end up with an image with KDE + GNOME
# init
# run_scripts base
run_scripts gnome
make_image "asahi-archport-gnome"
#
# # and again for XFCE
# init
# run_scripts base
# run_scripts xfce
# make_image "asahi-archport-xfce"
#
# # and again for MATE
# init
# run_scripts base
# run_scripts mate
# make_image "asahi-archport-mate"
#
# # and again for lxqt
# init
# run_scripts base
# run_scripts lxqt
# make_image "asahi-archport-lxqt"
#
# # and again for hyprland
# init
# run_scripts base
# run_scripts hyprland
# make_image "asahi-archport-hyprland"
#
# make_uefi_image "uefi-only"
