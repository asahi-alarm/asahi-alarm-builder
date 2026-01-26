#!/bin/sh
set -e

# we install mutter as wm for calamares setup, we'll remove after calamares is done
pacman --noconfirm --needed -S \
    asahi-desktop-meta arch-install-scripts pacman-contrib \
    zsh wget htop unzip strace rsync powertop git \
    man-db alsa-tools alsa-utils evtest iotop \
    mesa mesa-demos mesa-utils glmark2 \
    cosmic mutter \
    pipewire pipewire-jack pavucontrol wireplumber \
    calamares asahi-calamares-configs \
    firefox \
    bluez-utils pipewire-pulse bluez-tools
