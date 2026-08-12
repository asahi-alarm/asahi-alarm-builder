#!/bin/sh
set -e

mkdir -p /etc/NetworkManager/conf.d/

systemctl enable NetworkManager.service
