#!/bin/sh
set -e

pacman --noconfirm -S \
    asahi-desktop-meta arch-install-scripts pacman-contrib \
    zsh wget htop unzip strace rsync powertop git \
    man-db alsa-tools alsa-utils evtest iotop \
    mesa mesa-demos mesa-utils glmark2 \
    hyprland hyprcursor hyprgraphics hypridle hyprland-protocols hyprland-qt-support hyprland-guiutils \
    hyprlang hyprlock hyprpaper hyprpicker hyprpolkitagent hyprsunset hyprutils nwg-displays \
    nwg-dock-hyprland nwg-panel sddm uwsm kitty libnewt libnotify wofi wmenu labwc \
    pipewire pipewire-jack pavucontrol wireplumber \
    noto-fonts noto-fonts-cjk noto-fonts-emoji \
    calamares asahi-calamares-configs \
    firefox \
    bluez-utils pipewire-pulse bluez-tools
