#!/bin/sh
set -e

pacman --noconfirm -S \
    asahi-desktop-meta arch-install-scripts pacman-contrib \
    zsh wget htop unzip strace rsync powertop git \
    man-db alsa-tools alsa-utils evtest iotop \
    mesa mesa-demos mesa-utils glmark2 \
    plasma-meta konsole dolphin sddm kde-applications-meta \
    pipewire pipewire-jack pavucontrol wireplumber \
    noto-fonts noto-fonts-cjk noto-fonts-emoji \
    powerdevil plasma-nm networkmanager-qt \
    calamares asahi-calamares-configs \
    firefox \
    bluedevil bluez-utils pipewire-pulse bluez-tools
