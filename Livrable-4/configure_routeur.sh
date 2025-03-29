#!/bin/bash


if [[ $# -ne 1 ]];
  then 
cat <<DOC
Ce script est à utiliser pour configurer les VLANS du routeur

Usage : 
    $0 <interface>

Options : 
    <interface> l'interface sur laquelle configurer le VLAN ex : eth0
DOC
  fi

if ! ip addr | grep "$1" &> /dev/null;
  then
    echo "Erreur, votre interface n'existe pas !"
    exit 1
  fi

cat <<DEB >> /etc/sysctl.conf

net.ipv4.ip_forward=1

DEB

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

