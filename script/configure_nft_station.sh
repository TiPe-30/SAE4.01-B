#!/bin/bash

# configuration d'une installation de par feu sur les stations d'un réseaux : hors serveurs, routeurs, etc... pour les postes de travail

# on créé une interface pour lancer les scripts que l'on souhaite
# si on veut faire : test ping, installation, sauvegarde ou autre

#su -

amdin_station_user () {

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
}
FILE

#nft add rule input ...

}

admin_station_serveur () {
    
    echo "d"



}

admin_station_admin () {

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
}
FILE

#nft add rule
#nft add rule filter input drop
    
}

PS3="Votre choix : "
select item in "- Station Utilisateur" "- Station Administrateur" "- Station Serveur" "- Arrêt";
  do 
    
        case $REPLY in 
        1)
            echo "Vous êtes entrain d'administrer : $item"
            # réseau utilisateur

            amdin_station_user

            ;;
        2)
            #réseau administrateur
            echo "Vous êtes entrain d'administrer : $item"


            admin_station_admin

            ;;
        3) 
            # réseau serveur
            echo "Vous êtes entrain d'administrer : $item"

            admin_station_serveur

            ;;
        4)
            echo "Sortie de programme"
            exit 0
            ;;
        *)
            echo "Choix incorrect réassayez ...."
            ;;

        esac
  done


systemctl enable nftables.service
systemctl start nftables.service
systemctl restart ntfables.service

