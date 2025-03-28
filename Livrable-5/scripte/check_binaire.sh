#!/bin/bash
shopt -s globstar

if ! dpkg -l | grep binutils &> /dev/null;
  then 
    apt install binutils
  fi

# fichier ELF : readelf

for element in /bin/**;
  do 
    if readelf -h "$element" &> /dev/null;
      then 
        recap="$(readelf -d -h /bin/bash)"
        if ! echo "$recap" | grep DYN &> /dev/null;
          then 
            echo "Attention binaire non compilé avec l'option -PiE"
          fi
      fi
  done

echo "Tous les binaire possèdent bien DYN (fichier exécutable indépendant de la position)"
echo "Il n'y a plus qu'à vérifier la randomisation des adresse mémoires"