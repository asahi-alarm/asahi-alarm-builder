#!/bin/bash
set -e
echo "### Installing LiveCD specific packages"
pacman -S --noconfirm arch-install-scripts mkinitcpio-archiso pv lvm2 restic xfsprogs