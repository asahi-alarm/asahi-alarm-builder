#!/bin/sh

sed -i -e 's/^HOOKS=(base.*/HOOKS=(base asahi udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems fsck)/' \
	/etc/mkinitcpio.conf

if [ "$FSTYPE" = "btrfs" ]; then
	sed -i -e 's/^MODULES=()/MODULES=(btrfs)/' \
		/etc/mkinitcpio.conf
fi

mkdir -p /boot/efi/m1n1
pacman --noconfirm -S linux-asahi asahi-meta
