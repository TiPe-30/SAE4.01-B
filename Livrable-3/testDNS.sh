#!/bin/bash

if [[ $# -lt 1 ]];
  then 
    echo "Il faut rentrer des noms de domaines à tester"
    echo "Ex : $0 wwww.google.com www.facebook.com"
    exit 10
  fi

# vérification d'un nom de domaine du type 

for testHost in "$@";
  do
    if ! [[ $testHost =~ ^www.[a-z][a-z]*\.[a-z][a-z][a-z]*$ ]]; then 
    echo "Domaine invalide : $testHost "
      exit 1
    fi
  done

# communications avec toutes les adresse DNS

for host in "$@";
  do 
    if host "$host" &> /dev/null; then
        echo "la résolution de nom de : $host fonctionne"
      else 
        echo "la résolution de nom de : $host a échoué"
    fi
  done


