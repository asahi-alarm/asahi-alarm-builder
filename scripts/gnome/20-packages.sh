#!/bin/sh
set -e

pacman --noconfirm -S \
    asahi-desktop-meta arch-install-scripts pacman-contrib \
    zsh wget htop unzip strace rsync powertop git \
    man-db alsa-tools alsa-utils evtest iotop \
    xorg-server xf86-input-evdev xorg-xinput xorg-xinit xorg-xdpyinfo \
    mesa-demos mesa-utils \
    gnome gnome-tweaks \
    pipewire pipewire-jack pavucontrol wireplumber \
    noto-fonts noto-fonts-cjk noto-fonts-emoji \
    feh calamares asahi-calamares-configs \
    firefox \
    bluez-utils pipewire-pulse bluez-tools
