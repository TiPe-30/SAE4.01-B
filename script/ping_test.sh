#!/bin/bash

#on teste la connectivité des machines entre elles

#test si les paramètres donnés sont valides

if [[ $# -lt 1 ]];
  then 
    echo "Il faut entrer des adresse IP valides pour tester la connexion sur le réseaux"
    echo "$0 x.x.x.x y.y.y.y ou x et y sont des nombres"
    exit 10
  fi

# Vérification des adresses IPv4
regex_ip='^([0-9]{1,3}\.){3}[0-9]{1,3}$'
numArg=1

for adresse in "$@"; 
 do
    if ! [[ $adresse =~ $regex_ip ]]; then
        echo "Argument $numArg adresse IP invalide : $adresse"
        exit 2
    fi
    (( numArg++ ))
 done

for ip_adress in "$@"; 
  do

    if ping -c 1 -w 1 "$ip_adress" &> /dev/null;
      then
        echo "$USER communique correctement avec $ip_adress"
      else
        echo "$USER n'arrive pas à communiquer avec $ip_adress"
      fi

  done



