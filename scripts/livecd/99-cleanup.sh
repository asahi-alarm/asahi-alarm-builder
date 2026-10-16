#!/bin/bash
set -e
echo "### Cleaning up LiveCD specific packages"
pacman -Rns --noconfirm mkinitcpio-archiso pv