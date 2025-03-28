#!/bin/bash

# ---------------------- #
# Configuration Variables
# ---------------------- #
DOMAIN="local.pleter.ovh"
REALM="LOCAL.PLETER.OVH"
WORKGROUP="PLETER"
AD_GROUP="ad_write_group"  # Groupe AD ayant des droits d'écriture sur le partage
SHARE_PATH="/srv/samba/share"
HOMES_PATH="/srv/samba/homes"
QUOTA_SIZE="5G"

# ---------------------- #
# Installation des paquets nécessaires
# ---------------------- #
echo "[+] Installation des dépendances..."
apt update && apt install -y samba winbind libpam-winbind libnss-winbind acl quota realmd sssd krb5-user packagekit

# ---------------------- #
# Vérification de l'appartenance au domaine AD
# ---------------------- #
if ! wbinfo -t; then
    echo "[!] ERREUR: La machine n'est pas jointe au domaine AD."
    echo "[i] Rejoignez le domaine avec : realm join --user=Administrator $DOMAIN"
    exit 1
fi

# ---------------------- #
# Configuration des répertoires
# ---------------------- #
echo "[+] Création des répertoires..."
mkdir -p $HOMES_PATH $SHARE_PATH
chmod 770 $HOMES_PATH $SHARE_PATH
chown root:sambashare $HOMES_PATH $SHARE_PATH

# Associer Samba au groupe "sambashare"
usermod -aG sambashare smbd

# ---------------------- #
# Configuration des quotas
# ---------------------- #
echo "[+] Configuration des quotas..."
mount | grep " / " | awk '{print $1}' | xargs -I {} quotaoff -v {}
mount | grep " / " | awk '{print $1}' | xargs -I {} quotacheck -cum {}
mount | grep " / " | awk '{print $1}' | xargs -I {} quotaon -v {}
edquota -u -f / "$QUOTA_SIZE"

# ---------------------- #
# Configuration de PAM pour créer les dossiers utilisateurs
# ---------------------- #
echo "[+] Configuration de PAM pour les répertoires utilisateurs..."
echo "session required pam_mkhomedir.so skel=/etc/skel umask=0077" >> /etc/pam.d/common-session

# ---------------------- #
# Configuration de Samba
# ---------------------- #
echo "[+] Configuration de Samba..."
mv /etc/samba/smb.conf /etc/samba/smb.conf.bak
cat <<EOL > /etc/samba/smb.conf
[global]
   workgroup = $WORKGROUP
   security = ADS
   realm = $REALM
   idmap config * : backend = tdb
   idmap config * : range = 10000-99999
   template shell = /bin/bash
   winbind use default domain = yes
   winbind refresh tickets = yes

[homes]
   comment = Répertoire personnel sécurisé
   browseable = no
   writable = yes
   create mask = 0700
   directory mask = 0700
   valid users = %S
   force user = %S
   force group = sambashare

[shared]
   comment = Dossier partagé sécurisé
   path = $SHARE_PATH
   browseable = yes
   read only = yes
   write list = @$AD_GROUP
   force user = nobody
   force group = sambashare
EOL

# ---------------------- #
# Redémarrage des services
# ---------------------- #
echo "[+] Redémarrage de Samba et Winbind..."
systemctl restart smbd nmbd winbind

echo "[✔] Configuration terminée avec succès !"
