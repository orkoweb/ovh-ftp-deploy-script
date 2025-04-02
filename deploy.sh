#!/bin/bash

# Configuration
FTP_HOST="example.your-hosting.com" # Serveur FTP (sans le / final)
LOCAL_PATH='./' # Dossier local dans lequel se trouve le projet
REMOTE_PATH="/www" # Chez OVH c'est "/www"

# Vérification du fichier .netrc
if [ ! -f ~/.netrc ]; then
  echo "❌ Erreur: Le fichier ~/.netrc n'existe pas."
  echo "   Veuillez créer ce fichier selon les instructions du README.md"
  exit 1
fi

if [ ! -s ~/.netrc ]; then
  echo "❌ Erreur: Le fichier ~/.netrc est vide."
  echo "   Veuillez configurer ce fichier selon les instructions du README.md"
  exit 1
fi

echo "💾  Déploiement en cours sur OVH..."

# Sanitize les permissions d’images avant upload
find "$LOCAL_PATH" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" \) -exec chmod 644 {} \;

# Exécute la commande mirror et capture la sortie
OUTPUT=$(lftp -c "
open $FTP_HOST
user $(awk "/machine $FTP_HOST/ {getline; print \$2}" ~/.netrc) $(awk "/machine $FTP_HOST/ {getline; getline; print \$2}" ~/.netrc)
lcd '$LOCAL_PATH'
set ftp:sync-mode off
mirror -R --delete --verbose \
  --exclude "^\.git$" \
  --exclude .gitignore \
  --exclude README.md \
  --exclude .DS_Store \
  --exclude deploy.sh \
  --exclude ".*\.local\.conf$" \
  . '$REMOTE_PATH'
bye
")

# Filtrer les fichiers uploadés et supprimés
UPLOADED_FILES=$(echo "$OUTPUT" | grep -iE "transfert du fichier|uploading file|transferring file" | awk -F '«' '{print $2}' | awk -F '»' '{print $1}' | sed 's/^ *//')
DELETED_FILES=$(echo "$OUTPUT" | grep -iE "suppression de l'ancien fichier|removing|deleting" | awk -F '«' '{print $2}' | awk -F '»' '{print $1}' | sed 's/^ *//')

# Affichage du résultat
if [[ -n "$UPLOADED_FILES" ]]; then
  FILE_COUNT=$(echo "$UPLOADED_FILES" | wc -l | tr -d ' ')
  echo "📂 $FILE_COUNT fichier(s) uploadé(s) :"
  echo "$UPLOADED_FILES"
else
  echo "📂 Aucun fichier n'a été uploadé."
fi

if [[ -n "$DELETED_FILES" ]]; then
  FILE_COUNT=$(echo "$DELETED_FILES" | wc -l | tr -d ' ')
  echo "🗑️ $FILE_COUNT fichier(s) supprimé(s) :"
  echo "$DELETED_FILES"
else
  echo "🗑️ Aucun fichier n'a été supprimé."
fi

echo "✅ Déploiement terminé !"