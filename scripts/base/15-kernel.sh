#!/bin/sh

sed -i -e 's/^HOOKS=(base.*/HOOKS=(base asahi udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems fsck)/' \
	/etc/mkinitcpio.conf

mkdir -p /boot/efi/m1n1
pacman --noconfirm -S linux-asahi asahi-meta
