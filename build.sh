#!/usr/bin/env bash

set -e

BASE_IMAGE_URL="https://archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz"
BASE_IMAGE="$(basename "$BASE_IMAGE_URL")"

DL="$PWD/dl"
ROOT="$PWD/root"
FILES="$PWD/files"
IMAGES="$PWD/images"
IMG="$PWD/img"

EFI_UUID=2ABF-9F91
ROOT_UUID=725346d2-f127-47bc-b464-9dd46155e8d6
FSTYPE=ext4
export ROOT_UUID EFI_UUID FSTYPE

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
	bsdtar -xpf "$DL/$BASE_IMAGE" -C "$ROOT"

	cp -r "$FILES" "$ROOT"

	mount --bind "$ROOT" "$ROOT"

	cp "$ROOT"/etc/pacman.d/mirrorlist{,.orig}

	echo "## Installing keyring package..."
	pacstrap -G "$ROOT" asahi-alarm-keyring
}

save_base() {
	echo "## Saving base snapshot ($FSTYPE)..."
	tar -C "$ROOT" -cpf "$DL/base-$FSTYPE.tar" .
}

restore_base() {
	echo "## Restoring base snapshot ($FSTYPE)..."
	clean_mounts
	rm -rf "$ROOT"
	mkdir -p "$ROOT"
	tar -C "$ROOT" -xpf "$DL/base-$FSTYPE.tar"
	mount --bind "$ROOT" "$ROOT"
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
		zip -r ../"$imgname".zip -- *
		cd ..
		rm -rf "$img"
	)
	echo "### Done"
}

make_live_image() {
	imgname="$1"
	img="$IMAGES/$imgname"
	mkdir -p "$img"
	echo "## Making live ISO image $imgname"
	echo "### Creating ISO directory tree..."
	mkdir -p "$img/boot/grub"
	mkdir -p "$img/asahi/aarch64"
	mkdir -p "$img/asahi/boot"

	echo "### Moving initrd..."
	mv "$ROOT/boot/initramfs-live.img" "$img/asahi/boot/initramfs-linux.img"

	echo "### Copying kernel..."
	cp "$ROOT"/boot/vmlinuz* "$img/asahi/boot/vmlinuz"

	echo "### Creating squashfs..."
	mksquashfs "$ROOT" "$img/asahi/aarch64/airootfs.sfs" -noappend -comp zstd -wildcards -e 'var/cache/pacman/pkg/*' 'boot/initramfs-live.img'

	echo "### Configuring GRUB..."
	cat > "$img/boot/grub/grub.cfg" <<EOF
search --no-floppy --set=root --label "${imgname^^}"
linux /asahi/boot/vmlinuz archisobasedir=asahi archisolabel="${imgname^^}" rw fstab=no
initrd /asahi/boot/initramfs-linux.img
boot
EOF

	echo "### Creating bootable ISO with grub-mkrescue..."
	grub-mkrescue -o "$IMAGES/$imgname.iso" -volid "${imgname^^}" "$img"
	
	echo "### Cleaning up temporary files..."
	rm -rf "$img"
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
	size=$((size + (size / 8) + 256))
	echo "### Padded size: $size MiB"
	rm -f "$img/root.img"
	truncate -s "${size}M" "$img/root.img"
	echo "### Making filesystem ($FSTYPE)..."
	if [ "$FSTYPE" = "btrfs" ]; then
		mkfs.btrfs -U "$ROOT_UUID" -L "asahi-root" "$img/root.img"
		echo "### Creating btrfs subvolumes (@, @home)..."
		mount -o loop,subvolid=5 "$img/root.img" "$IMG"
		btrfs subvolume create "$IMG/@"
		btrfs subvolume create "$IMG/@home"
		umount "$IMG"
		echo "### Mounting @ as / ..."
		mount -o loop,subvol=@ "$img/root.img" "$IMG"
	else
		mkfs.ext4 -U "$ROOT_UUID" -L "asahi-root" -O '^metadata_csum' "$img/root.img"
		mount -o loop "$img/root.img" "$IMG"
	fi
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
		zip -1 -r ../"$imgname".zip -- *
		cd ..
		rm -rf "$img"
	)
	echo "### Done"
}

# ext4 variants
init
run_scripts base
make_image "asahi-base"

run_scripts livecd
make_live_image "asahi-base-livecd"

run_scripts desktop
make_image "asahi-desktop"

make_uefi_image "uefi-only"

# btrfs variants
FSTYPE=btrfs
export FSTYPE

init
run_scripts base
make_image "asahi-base-btrfs"
run_scripts desktop
make_image "asahi-desktop-btrfs"
