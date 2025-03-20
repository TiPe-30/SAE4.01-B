#!/bin/bash

read -r -p "Entrez l'interface sur laquelle vous souhaitez créer les vlan : " interface

cat <<USER

auto $interface.10
iface $interface.10 inet static
    address 10.0.10.1
    netmask 255.255.255.0

USER

#configuration du vlan pour les administrateurs

cat <<ADMIN

auto $interface.20
iface $interface.20 inet static
    address 10.0.20.1
    netmask 255.255.255.0

ADMIN

#configuration du vlan pour le serveur

cat <<SERV

auto $interface.30
iface $interface.30 inet static
    address 10.0.30.1
    netmask 255.255.255.0

SERV

#configuration de la DMZ

cat <<DMZ

auto $interface.40
iface $interface.40 inet static
    address 10.0.40.1
    netmask 255.255.255.0

DMZ

#sudo systemctl enable networking

# configurer le par-feu nftables

cat <<FILE
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

#systemctl enable nftables.service
#systemctl start nftables.service
#systemctl restart nftables.service