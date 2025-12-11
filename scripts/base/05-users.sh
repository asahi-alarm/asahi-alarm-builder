#!/bin/sh
set -e

PASSWORD_HASH=$(openssl passwd -6 'root')
usermod --password "$PASSWORD_HASH" root
