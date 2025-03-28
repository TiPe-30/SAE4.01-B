#!/bin/bash

if [[ $# -lt 1 ]];
  then 
  cat <<DOC
Script pour test de résolution dns

Usage :
    $0 <destination> ...

Option : 
    <destination> nom de domaine de l'hôte ex : www.facebook.com, facebook.com, facebook.fr
DOC
  exit 1
  fi

# vérification d'un nom de domaine du type 

for testHost in "$@";
  do
    if ! [[ $testHost =~ ^[a-z][a-z]*\.[a-z][a-z][a-z]*\.?[a-z]*$ ]]; then 
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


