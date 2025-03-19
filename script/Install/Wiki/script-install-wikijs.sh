#!/bin/bash
###########################CONSTANTE############################################
#CONST DEFINITIVE
#
readonly ROUGE='\033[0;31m'
readonly JAUNE='\033[0;33m'
readonly VERT='\033[0;32m'
readonly GRAS='\033[1m'
readonly NORMAL='\033[0m'
readonly SOULIGNE='\033[4m'
readonly SOURCE_DOCKER_COMPOSE_CONFIG_NAME='docker-compose.yml'
readonly SOURCE_WIKI_CONFIG_NAME='config.yml'
readonly SMILEY='\xF0\x9F\x98\x8A'
readonly DEST_APP_RELATIVE_PATH='Docker/WikiJs'

#CONSTANTE A L'EXECUTION

SOURCE_DOCKER_COMPOSE_CONFIG_FILE="$(dirname "$(realpath "$0")")/$SOURCE_DOCKER_COMPOSE_CONFIG_NAME"
SOURCE_WIKI_CONFIG_FILE="$(dirname "$(realpath "$0")")/$SOURCE_WIKI_CONFIG_NAME"
DEST_APP_ABSOLUTE_PATH="$HOME/$DEST_APP_RELATIVE_PATH"
DEST_DOCKER_COMPOSE_CONFIG_FILE="${DEST_APP_ABSOLUTE_PATH}/$SOURCE_DOCKER_COMPOSE_CONFIG_NAME"
DEST_WIKI_CONFIG_FILE="$DEST_APP_ABSOLUTE_PATH/$SOURCE_WIKI_CONFIG_NAME"

####################FONCTION####################################################

verifier_existence_fichier_config() {

if [ ! -e "$DEST_DOCKER_COMPOSE_CONFIG_FILE" ]; then
	echo -e "${ROUGE}${GRAS}Erreur critique :${NORMAL} ${SOULIGNE}${DEST_DOCKER_COMPOSE_CONFIG_FILE}${NORMAL} ${JAUNE}n'existe plus.${NORMAL}"
    	echo -e "${ROUGE}${GRAS}Action requise :${NORMAL} ${JAUNE}Veuillez vérifier si le fichier a été altéré ou supprimé.${NORMAL}"
    	echo -e "${ROUGE}${GRAS}Conseil :${NORMAL} Avant de démarrer le serveur, veillez à replacer ${SOURCE_DOCKER_COMPOSE_CONFIG_NAME} de configuration dans ${DEST_APP_RELATIVE_PATH}."	
fi
if [ ! -e "$DEST_WIKI_CONFIG_FILE" ]; then
	echo -e "${ROUGE}${GRAS}Erreur critique :${NORMAL} ${SOULIGNE}${DEST_WIKI_CONFIG_FILE}${NORMAL} ${JAUNE}n'existe plus.${NORMAL}"
    	echo -e "${ROUGE}${GRAS}Action requise :${NORMAL} ${JAUNE}Veuillez vérifier si le fichier a été altéré ou supprimé.${NORMAL}"
    	echo -e "${ROUGE}${GRAS}Conseil :${NORMAL} Avant de démarrer le serveur, veillez à replacer ${SOURCE_WIKI_CONFIG_NAME} de configuration dans ${DEST_APP_RELATIVE_PATH}."	
fi
}

################################################################################
###################MAIN#########################################################


#Vérifier utilisateur est root
if [ "$EUID" -ne 0 ]; then
  echo -e "Ce script doit être exécuté en tant que ${GRAS}root${NORMAL}." 
  echo -e "(Astuce : utilisez ${GRAS}-y${NORMAL} pour répondre automatiquement oui)"
  exit 1 #On annule l'installation et sort du script
fi

#Récuperer autorisation installation
if [[ "$1" == "-y" ]]; then
    reponse="oui"
else
    # Afficher un message
    echo "Voulez-vous continuer ? (oui/non) [non]"
    
    # Lire la réponse de l'utilisateur, avec 'non' comme valeur par défaut
    read -rp "Réponse : " reponse
    reponse=${reponse:-non}
fi


#Vérifier si l'installation est autorisé

if [[ "$reponse" != "oui" ]]; then
  exit 1 #On annule l'installation et sort du script
fi

#Installation


echo "==================== Debut de l'installation ===================="
#Installer les dépendances
apt-get install docker.io -y

apt-get install docker-compose -y

docker pull postgres:15-alpine

docker pull requarks/wiki:latest



mkdir -p "$DEST_APP_ABSOLUTE_PATH"
[ -f "$SOURCE_DOCKER_COMPOSE_CONFIG_FILE" ] && cp "$SOURCE_DOCKER_COMPOSE_CONFIG_FILE" "$DEST_APP_ABSOLUTE_PATH"
[ -f "$SOURCE_WIKI_CONFIG_FILE" ] && cp "$SOURCE_WIKI_CONFIG_FILE" "$DEST_APP_ABSOLUTE_PATH"


echo "==================== Fin de l'installation ====================="

#Affiche message utilisateur

verifier_existence_fichier_config


echo -e "Accédez au répertoire ${SOULIGNE}${DEST_APP_ABSOLUTE_PATH}${NORMAL}, puis exécutez la commande ${GRAS}docker-compose up${NORMAL} en tant que root pour démarrer le serveur Wiki."
echo -e "Pour lancer le serveur de manière détachée, utilisez ${GRAS}docker-compose up -d${NORMAL}."
echo -e "${VERT}Avant de lancer serveur, assurez-vous que le port externe attribué est disponible.  ${SMILEY} ${NORMAL}"


