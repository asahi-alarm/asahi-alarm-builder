#!/bin/bash
set -e
echo "### Installing LiveCD specific packages"
pacman -S --noconfirm mkinitcpio-archiso pv lvm2
