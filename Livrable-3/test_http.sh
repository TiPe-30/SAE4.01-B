#!/bin/bash

# si l'utilisateur n'entre pas de destination on lui affiche une documentation

if [[ $# -lt 1 ]];
  then 
cat <<DOC
script de test http sur le port 80

Usage : 
    $0 <destination> ... 

Options : 
    <destination> hostname or Ip adress

entrez des nom de domaines ou des adresses ip valides !
DOC
    exit 1
  fi

# vérification du nom de domaine passé au script ou de l'adresse IP
for websiteCheck in "$@";
  do 
    # check de l'adresse Ip et si ce n'est pas une adresse Ip on vérifie qu'il s'agit d'un nom de domaine valide
    if [[ ! $websiteCheck =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] || [[ ! $websiteCheck =~ ^[a-z][a-z]*\.[a-z][a-z][a-z]*\.?[a-z]*$ ]];
     then 
      echo "Le nom de domaine ou l'adresse Ip est invalide : $websiteCheck"
      exit 1
     fi
  done

# on parcours les noms de domaines données en paramètres
for website in "$@";
  do 
    if nc -w 1 "$website" 80;
      then 
        echo "La communication avec le site web : $website fonctionne !"
      else 
        echo "La communication avec le site web : $website ne fonctionne pas !"
      fi
  done


