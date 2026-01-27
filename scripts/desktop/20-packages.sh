#!/bin/sh
set -e

pacman --noconfirm --needed -S \
    asahi-desktop-meta arch-install-scripts pacman-contrib \
    zsh wget htop unzip strace rsync powertop git \
    man-db alsa-tools alsa-utils evtest iotop \
    mesa mesa-demos mesa-utils glmark2 \
    pipewire pipewire-jack pavucontrol wireplumber \
    cage calamares asahi-calamares-configs \
    firefox asahi-audio \
    bluez-utils pipewire-pulse bluez-tools
