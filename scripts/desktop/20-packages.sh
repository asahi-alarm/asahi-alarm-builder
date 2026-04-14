#!/bin/sh
set -e

pacman --noconfirm --needed -S \
    asahi-desktop-meta pacman-contrib \
    zsh wget htop unzip strace rsync powertop git \
    man-db alsa-tools alsa-utils evtest iotop \
    mesa mesa-demos mesa-utils glmark2 \
    pipewire pipewire-jack pavucontrol wireplumber \
    cage xorg-server-xwayland calamares asahi-calamares-configs \
    firefox \
    bluez-utils pipewire-pulse bluez-tools
