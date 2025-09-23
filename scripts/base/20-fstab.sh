#!/bin/sh

cat >/etc/fstab <<EOF
UUID=$ROOT_UUID / btrfs rw,relatime,x-systemd.growfs,compress=zstd:1,subvol=@ 0 0
UUID=$ROOT_UUID /home btrfs rw,relatime,x-systemd.growfs,compress=zstd:1,subvol=@home 0 0
UUID=$EFI_UUID /boot/efi vfat rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro    0 2
EOF
