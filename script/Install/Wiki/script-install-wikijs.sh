#!/bin/bash
###########################CONSTANTE############################################
#CONST DEFINITIVE
#
readonly ROUGE='\033[0;31m'
readonly JAUNE='\033[0;33m'
readonly GRAS='\033[1m'
readonly NORMAL='\033[0m'
readonly SOULIGNE='\033[4m'
readonly SOURCE_DOCKER_COMPOSE_CONFIG_NAME='docker-compose.yml'
readonly SOURCE_WIKI_CONFIG_NAME='config.yml'
readonly SMILEY='\xF0\x9F\x98\x8A'
readonly DEST_APP_RELATIVE_PATH='Docker/WikiJs'

#CONSTANTE A L'EXECUTION
# Vérifier si UTF-8 est supporté
if locale charmap | grep -qi 'utf-8'; then
    readonly UTF8_SUPPORTED=true
else
    readonly UTF8_SUPPORTED=false
fi

SOURCE_DOCKER_COMPOSE_CONFIG_FILE="$(dirname "$(realpath "$0")")/$SOURCE_DOCKER_COMPOSE_CONFIG_NAME"
SOURCE_WIKI_CONFIG_FILE="$(dirname "$(realpath "$0")")/$SOURCE_WIKI_CONFIG_NAME"
DEST_APP_ABSOLUTE_PATH="$(realpath "$HOME/$DEST_APP_RELATIVE_PATH")"


####################FONCTION####################################################

verifier_existence_fichier_config() {

if [ ! -e "$SOURCE_CONFIG_FILE" ]; then
    	if [ "$UTF8_SUPPORTED" == "true" ]; then
  		echo -e "${ROUGE}${GRAS}Erreur critique :${NORMAL} ${SOULIGNE}${SOURCE_CONFIG_FILE}${NORMAL} ${JAUNE}n'existe plus.${NORMAL}"
    		echo -e "${ROUGE}${GRAS}Action requise :${NORMAL} ${JAUNE}Veuillez vérifier si le fichier a été altéré ou supprimé.${NORMAL}"
    		echo -e "${ROUGE}${GRAS}Conseil :${NORMAL} Assurez-vous que le fichier n'a pas été déplacé ou renommé.${NORMAL}"	
    	else
		echo    "Erreur critique : ${SOURCE_CONFIG_FILE} n'existe plus."
    		echo    "Action requise : Veuillez vérifier si le fichier a été altéré ou supprimé."
    		echo    "Conseil : Assurez-vous que le fichier n'a pas été déplacé ou renommé."	
    	fi
   exit 1 #Quitter le script avec code 1 
fi
}

################################################################################
###################MAIN#########################################################


#Vérifier utilisateur est root
if [ "$EUID" -ne 0 ]; then
  echo "Ce script doit être exécuté en tant que root." 
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
#A chaque installation et télechargement, on vérifie si le fichier de configuration a été altéré
#afin d'eviter de consommer de l'espace disque.

verifier_existence_fichier_config 
echo "==================== Debut de l'installation ===================="
#Installer les dépendances
apt-get install docker.io -y
verifier_existence_fichier_config 
apt-get install docker-compose -y
verifier_existence_fichier_config 
docker pull postgres:15-alpine
verifier_existence_fichier_config 
docker pull requarks/wiki:latest

verifier_existence_fichier_config 

mkdir -p "$HOME/Docker/WikiJs"
cp "$SOURCE_DOCKER_COMPOSE_CONFIG_FILE" "$DEST_APP_ABSOLUTE_PATH"
cp "$SOURCE_WIKI_CONFIG_FILE" "$DEST_APP_ABSOLUTE_PATH"


echo "==================== Fin de l'installation ====================="

#Affiche message utilisateur
if [ "$UTF8_SUPPORTED" == "true" ]; then
    echo -e "Accédez au répertoire ${SOULIGNE}${DEST_APP_DIR}${NORMAL}, puis exécutez la commande ${GRAS}docker-compose up${NORMAL} en tant que root pour démarrer le serveur Wiki."
    echo "Avant de le lancer, assurez-vous que le port externe attribué est disponible."
    echo -e "${SMILEY}" 
else
    echo "Accédez au répertoire ${DEST_APP_DIR}, puis exécutez la commande  docker-compose up  en tant que root pour démarrer le serveur Wiki."
    echo 'Avant de le lancer, assurez-vous que le port externe attribué est disponible.'
    echo ':)'  
fi
