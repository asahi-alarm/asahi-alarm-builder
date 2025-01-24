#!/bin/sh
set -e

pacman --noconfirm -S \
    asahi-desktop-meta arch-install-scripts pacman-contrib \
    zsh wget htop unzip strace rsync powertop git \
    man-db alsa-tools alsa-utils evtest iotop \
    mesa mesa-demos mesa-utils \
    gnome gnome-tweaks \
    pipewire pipewire-jack pavucontrol wireplumber \
    noto-fonts noto-fonts-cjk noto-fonts-emoji \
    calamares asahi-calamares-configs \
    firefox \
    bluez-utils pipewire-pulse bluez-tools
