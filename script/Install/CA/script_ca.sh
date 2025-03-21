#!/bin/bash
###########################CONSTANTE############################################

readonly DAYS_VALID=3650  # 10 ans

source script_ca_commun.sh
readonly COMMON_NAME="PLETER CA"

################################################################################
###################MAIN#########################################################


# Demande du mot de passe pour la clé privée de la CA
echo -e "Entrez un ${GRAS}mot de passe${NORMAL} pour la ${GRAS}clé privé${NORMAL} de l'Autorité de Certification :"
read -rs CA_PASSPHRASE

echo -e "Confirmez le ${GRAS}mot de passe${NORMAL} :"
read -rs CA_PASSPHRASE_CONFIRM

# Vérification de la confirmation
if [ "$CA_PASSPHRASE" != "$CA_PASSPHRASE_CONFIRM" ]; then
    echo "Les mots de passe ne correspondent pas. Annulation."
    exit 1
fi

# Création du répertoire CA
mkdir -p "$CA_DIR"
chmod 700 "$CA_DIR"

# Génération de la clé privée (4096 bits)
openssl genpkey -algorithm RSA -out "$CA_DIR"/ca.key -aes256 -pass pass:"$CA_PASSPHRASE" -pkeyopt rsa_keygen_bits:4096
chmod 400 "$CA_DIR"/ca.key

# Création du certificat auto-signé de la CA
openssl req -key "$CA_DIR"/ca.key -new -x509 -out "$CA_DIR"/ca.crt -passin pass:"$CA_PASSPHRASE" -days $DAYS_VALID -subj "/C=$COUNTRY/L=$LOCALITY/O=$ORGANIZATION/CN=$COMMON_NAME"

echo -e "L'Autorité de Certification a été créée dans le dossier ${SOULIGNE}$CA_DIR${NORMAL}."
 
