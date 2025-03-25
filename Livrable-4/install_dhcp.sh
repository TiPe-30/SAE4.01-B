#!/bin/bash

if [[ $# -ne 6 ]];
  then 
cat <<DOC
Script de configuration du DHCP, ce script utilise kea comme DHCP
pour la machine qui l'execute

Usage : 
    $0 <interface> <network> <router> <addrDeb> <addrFin> <IpServerDNS>

Options : 
    <interface> : l'interface sur laquelle on veut configurer le serveur ex : eth0
    <network> : l'adresse Ipv4 du routeur 
    <addrDeb> : adresse Ipv4 maximale pour la plage d'allocation d'adresse
    <addrFin> : adresse Ipv4 minimale pour plage adresse
    <IpServerDNS> : adresse Ipv4 du serveur DNS
DOC
    exit 1
  fi

if ! dpkg -l | grep kea-dhcp4-server &> /dev/null;
  then 
    apt install kea-dhcp4-server
  fi

if ! systemctl is-active kea-dhcp4-server --quiet;
  then 
    systemctl enable kea-dhcp4-server
    systemctl start kea-dhcp4-server
    systemctl restart kea-dhcp4-server
  fi

# on créé un backup du fichier
mv -i /etc/kea/kea-dhcp4.conf /etc/kea/kea-dhcp4.conf.bkp

# configuration du fichier du serveur

cat <<DHCP > /etc/kea/kea-dhcp4.conf

{
    "Dhcp4": {
        "interfaces-config": {
            "interfaces": [
                "$1"
            ]
        },
        "valid-lifetime": 691200,
        "renew-timer": 345600,
        "rebind-timer": 604800,
        "authoritative": true,
        "lease-database": {
            "type": "memfile",
            "persist": true,
            "name": "/var/lib/kea/kea-leases4.csv",
            "lfc-interval": 3600
        },
        "subnet4": [
            {
                "subnet": "$2",
                "pools": [
                    {
                        "pool": "$4 - $5"
                    }
                ],
                "option-data": [
                    {
                        "name": "domain-name-servers",
                        "data": "$6"
                    },
                    {
                        "name": "domain-search",
                        "data": "it-connect.local"
                    },
                    {
                        "name": "routers",
                        "data": "$3"
                    }
                ]
            }
        ]
    }
}

DHCP

systemctl restart kea-dhcp4-server.service