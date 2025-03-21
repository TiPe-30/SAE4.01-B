#!/bin/bash
 ###########################CONSTANTE############################################
#CONST MISE EN FORME
#
readonly ROUGE='\033[0;31m'
export ROUGE
readonly JAUNE='\033[0;33m'
export JAUNE
readonly GRAS='\033[1m'
export GRAS
readonly NORMAL='\033[0m'
export NORMAL
readonly SOULIGNE='\033[4m'
export SOULIGNE

#CONST ORGANISATION CA
readonly COUNTRY="FR"
export COUNTRY
readonly LOCALITY="Grenoble"
export LOCALITY
readonly ORGANIZATION="PLETER"
export ORGANIZATION



#CONST GESTION OPENSSH CA

readonly CA_DIR='ca'
export CA_DIR