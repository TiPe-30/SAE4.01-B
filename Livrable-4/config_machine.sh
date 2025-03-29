#!/bin/bash

# configurer apt
cat <<CONF > /etc/apt/source.list
deb http://deb.debian.org/debian bookworm main contrib non-free-firmware
deb-src http://deb.debian.org/debian bookworm main contrib non-free-firmware
deb http://deb.debian.org/debian bookworm-updates main contrib non-free-firmware
deb-src http://deb.debian.org/debian bookworm-updates main contrib non-free-firmware
deb http://security.debian.org/debian-security/ bookworm-security main contrib non-free-firmware
deb-src http://security.debian.org/debian-security/ bookworm-security main contrib non-free-firmware
CONF

#configurer le DNS
/etc/resolv.conf
nameserver 152.77.1.22


apt install nftables
apt install ssh
apt install traceroute