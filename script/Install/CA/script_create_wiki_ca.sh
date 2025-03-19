#!/bin/bash
###########################CONSTANTE############################################

readonly CLIENT_DIR='wiki-ca'
readonly DAYS_VALID=365  # 1 an

source script_ca_commun.sh

readonly COMMON_NAME='wiki.local.pleter.ovh'

################################################################################
###################MAIN#########################################################


# Vérification de l'existence de la CA
if [ ! -f "$CA_DIR/ca.key" ] || [ ! -f "$CA_DIR/ca.crt" ]; then
    echo -e "Erreur : L'Autorité de Certification n'existe pas. Veuillez exécuter ${SOULIGNE}script_ca.sh${NORMAL} d'abord."
    exit 1
fi

# Demande du mot de passe pour la clé privée de la CA
echo -e "Entrez le mot de passe de ${GRAS}l'Autorité de Certification${NORMAL} pour signer le certificat du client :"
read -rs CA_PASSPHRASE

# Création du répertoire du client
mkdir -p "$CLIENT_DIR"
chmod 700 "$CLIENT_DIR"

# Génération de la clé privée (4096 bits)
openssl genpkey -algorithm RSA -out "$CLIENT_DIR"/client.key -aes256 -pass pass:"$CA_PASSPHRASE" -pkeyopt rsa_keygen_bits:4096
chmod 400 "$CLIENT_DIR"/client.key

# Création de la demande de certificat (CSR)
openssl req -new -key "$CLIENT_DIR"/client.key -out "$CLIENT_DIR"/client.csr -passin pass:"$CA_PASSPHRASE" -subj "/C=$COUNTRY/L=$LOCALITY/O=$ORGANIZATION/CN=$COMMON_NAME"

# Signature du certificat du client avec la CA
openssl x509 -req -in "$CLIENT_DIR"/client.csr -CA "$CA_DIR"/ca.crt -CAkey "$CA_DIR"/ca.key -CAcreateserial -out "$CLIENT_DIR"/client.crt -passin pass:"$CA_PASSPHRASE" -days "$DAYS_VALID"

echo -e "Le certificat TLS de ${GRAS}$COMMON_NAME${NORMAL} a été généré dans le dossier ${SOULIGNE}$CLIENT${NORMAL}."
