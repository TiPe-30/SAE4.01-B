#!/bin/bash

#on teste la connectivité des machines entre elles

#test si les paramètres donnés sont valides

if [[ $# -lt 1 ]];
  then 
cat <<DOC
script de test de connectivite entre deux machines

Usage: 
    $0 <destination> ...

Options : 
    <destination> la ou les destination en adresse Ipv4

DOC
  exit 1
  fi

# Verification des adresses IPv4
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

    if ping -w 1 "$ip_adress" &> /dev/null;
      then
        echo "$USER communique correctement avec $ip_adress"
      else
        echo "$USER n'arrive pas à communiquer avec $ip_adress"
      fi

  done


