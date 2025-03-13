#!/bin/bash

if [[ $# -lt 1 ]];
  then 
    echo "Il faut rentrer des noms de domaines à tester"
    echo "Ex : $0 wwww.google.com www.facebook.com"
    exit 10
  fi


for host in "$@";
  do 

    if host "$host";
      then
        echo "la résolution de nom de : $host fonctionne"
      else 
        echo "la résolution de nom de : $host a échoué"

  done


