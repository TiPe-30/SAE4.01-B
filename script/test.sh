#!/bin/bash

read -r -p "Entrez l'interface que vous souhaitez configurer : " interface

read -r -p "Entrez l'adresse du réseau en notation CIDR(ex : 192.168.13.24/24) : " reseau

read -r -p "Entrez l'adresse Ip de votre routeur : " routeur

echo "Entrez la plage d'adresse que vous souhaitez (tapez l'adresse de début + l'adresse de fin) à la suite : "
read -r addrDebut 
read -r addrFin

read -r -p "Entrez l'adresse ip du serveur DNS : " dns

cat <<DHCP

{
    "Dhcp4": {
        "interfaces-config": {
            "interfaces": [
                "$interface"
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
                "subnet": "$reseau",
                "pools": [
                    {
                        "pool": "$addrDebut - $addrFin"
                    }
                ],
                "option-data": [
                    {
                        "name": "domain-name-servers",
                        "data": "$dns"
                    },
                    {
                        "name": "domain-search",
                        "data": "it-connect.local"
                    },
                    {
                        "name": "routers",
                        "data": "$routeur"
                    }
                ]
            }
        ]
    }
}

DHCP