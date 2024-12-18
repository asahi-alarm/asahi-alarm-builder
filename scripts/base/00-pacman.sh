#!/bin.sh
set -e

sed -i -e '/\[core\]/i [asahi-alarm]\nInclude = /etc/pacman.d/mirrorlist.asahi-alarm\n' /etc/pacman.conf

cp /files/mirrorlist.asahi-alarm /etc/pacman.d/mirrorlist.asahi-alarm

pacman-key --init
pacman-key --populate archlinuxarm asahi-alarm
