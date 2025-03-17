#!/bin/bash

read -r -p "Entrez l'interface sur laquelle vous souhaitez créer les vlan : " interface

if ! ip addr | grep "$interface" &> /dev/null;
  then
    echo "Erreur, votre interface n'existe pas !"
    exit 1
  fi

cat <<DEB >> /etc/sysctl.conf

net.ipv4.ip_forward=1

DEB

if ! dpkg -l | grep vlan &> /dev/null;then
    apt install vlan
fi

echo "8021q" | sudo tee -a /etc/modules

# configuration du vlan pour les utilisateurs
cat <<USER >> /etc/network/interfaces

auto $interface.10
iface $interface.10 inet static
    address 10.0.10.1
    netmask 255.255.255.0

USER

#configuration du vlan pour les administrateurs

cat <<ADMIN >> /etc/network/interfaces

auto $interface.20
iface $interface.20 inet static
    address 10.0.20.1
    netmask 255.255.255.0

ADMIN

#configuration du vlan pour le serveur

cat <<SERV >> /etc/network/interfaces

auto $interface.30
iface $interface.30 inet static
    address 10.0.30.1
    netmask 255.255.255.0

SERV

#configuration de la DMZ

cat <<DMZ >> /etc/network/interfaces

auto $interface.40
iface $interface.40 inet static
    address 10.0.40.1
    netmask 255.255.255.0

DMZ

sudo systemctl enable networking

# configurer le par-feu nftables

cat <<FILE > /etc/nftables.conf
#!/usr/sbin/nft -f

flush ruleset

table ip filter {
    chain input {
        type filter hook input priority 0; policy accept;
    }

    chain output{
        type filter hook output priority 0; policy accept;
    }

    chain forward{
        type filter hook forward priority 0; policy accept;
    }
}

table ip nat {
    chain prerouting {
        type nat hook prerouting priority -100; policy accept;
    }

    chain postrouting {
        type nat hook postrouting priority 100; policy accept;
    }

}
FILE

systemctl enable nftables.service
systemctl start nftables.service
systemctl restart nftables.service

# ajout des règles du par feu par la suite

# nft add rule filter input ...

