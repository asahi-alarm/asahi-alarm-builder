#!/bin/bash
set -e
echo "### Generating LiveCD initramfs"
# Create a temporary config based on the system's current one
cp /etc/mkinitcpio.conf /etc/mkinitcpio-live.conf

# 1. Add necessary modules for Live ISO (USB and Filesystems)
sed -i 's/^MODULES=(.*/MODULES=(isofs squashfs uas usb_storage usbhid xhci_hcd xhci_pci xhci_plat_hcd)/' /etc/mkinitcpio-live.conf

# 2. Remove autodetect (to ensure all drivers are included) 
# and add archiso hooks
sed -i 's/autodetect //' /etc/mkinitcpio-live.conf
sed -i 's/\bblock\b/block archiso/' /etc/mkinitcpio-live.conf

kver=$(ls /lib/modules/ | head -n1)
echo "Detected kernel version: $kver"

mkinitcpio -c /etc/mkinitcpio-live.conf -k "$kver" -g "/boot/initramfs-live.img"

# Clean up temporary config
rm /etc/mkinitcpio-live.conf
