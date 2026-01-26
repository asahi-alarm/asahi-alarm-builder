#!/bin/sh
set -e

pacman --noconfirm --needed -S \
    asahi-desktop-meta arch-install-scripts pacman-contrib \
    zsh wget htop unzip strace rsync powertop git \
    man-db alsa-tools alsa-utils evtest iotop \
    mesa mesa-demos mesa-utils glmark2 \
    mate mate-extra gvfs feh lightdm-gtk-greeter network-manager-applet system-config-printer xorg-xinit \
    pipewire pipewire-jack pavucontrol wireplumber \
    calamares asahi-calamares-configs \
    firefox \
    bluez-utils pipewire-pulse bluez-tools blueman
