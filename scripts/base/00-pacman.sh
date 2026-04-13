#!/bin/sh
set -e

sed -i -e 's/^#ParallelDownloads = 5/ParallelDownloads = 5/' /etc/pacman.conf
sed -i -e '/\[core\]/i [asahi-alarm]\nInclude = /etc/pacman.d/mirrorlist.asahi-alarm\n' /etc/pacman.conf

cp /files/mirrorlist.asahi-alarm /etc/pacman.d/mirrorlist.asahi-alarm

# Create system users (notably `alpm`) declared in /usr/lib/sysusers.d/*.
# Required since pacman.conf now ships DownloadUser = alpm by default.
systemd-sysusers

pacman-key --init
pacman-key --populate
