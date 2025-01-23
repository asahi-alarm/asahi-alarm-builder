#!/bin/sh
set -e

# first install mesa-asahi to avoid conflicts with mesa
pacman --noconfirm -S mesa-asahi
pacman --noconfirm -S \
    asahi-desktop-meta arch-install-scripts pacman-contrib \
    zsh wget htop unzip strace rsync powertop git \
    man-db alsa-tools alsa-utils evtest iotop \
    mesa-demos mesa-utils \
    plasma-meta konsole dolphin sddm kde-applications-meta \
    pipewire pipewire-jack pavucontrol wireplumber phonon-qt5-gstreamer \
    noto-fonts noto-fonts-cjk noto-fonts-emoji \
    powerdevil plasma-nm networkmanager-qt \
    calamares asahi-calamares-configs \
    firefox \
    bluedevil bluez-utils pipewire-pulse bluez-tools
