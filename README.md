# OVH FTP Deploy Script

---

Ce script permet de déployer un projet via FTP sur un serveur OVH mutualisé en utilisant `lftp`.
Il compare automatiquement les fichiers locaux et distants pour ne transférer que les éléments modifiés, ajoutés ou supprimés, optimisant ainsi le temps de déploiement.

Les instructions décrites ci-dessous concernent l'utilisation de ce sricpt sur macOS.

---

## Prérequis

`lftp` doit être installé pour que le script fonctionne correctement. Voici comment l'installer via Homebrew :

```sh
brew install lftp
```

## Installation

1. **Créer un fichier `.netrc`** dans son répertoire utilisateur `~/`, à la main ou via :
   ```sh
   touch ~/.netrc
   chmod 600 ~/.netrc
   ```
   
   Un fichier d'exemple `netrc.example` est disponible dans ce dépôt.

2. Au sein du ficher `.netrc`, ajouter les informations de connexion FTP et enregistrer.
   ```txt
   machine example.your-hosting.com
   login VOTRE_LOGIN
   password VOTRE_MOTDEPASSE
   ```

   > **⚠️ Sécurité** : ne jamais versionner le fichier `.netrc` contenant les identifiants réels. Ce fichier doit rester uniquement sur la machine locale.

3. Télécharger le fichier `deploy.sh` et le déposer à la racine du dossier de son projet local

4. Remplir les informations nécessaires dans le fichier `deploy.sh` : 
   - `FTP_HOST` : Adresse du serveur FTP (sans le / final)
   - `LOCAL_PATH` : Dossier local du projet
   - `REMOTE_PATH` : Dossier distant (/www chez OVH)

5. Donner les permissions d'exécution :
   ```sh
   chmod +x deploy.sh
   ```

## Déploiement

Pour lancer le script :
```sh
./deploy.sh
```

### Exclusions

Le script ignore certains fichiers/dossiers par défaut :

- `.git`, `.gitignore`, `README.md`, `.DS_Store`, `deploy.sh`
- Modifier la section `--exclude` dans `deploy.sh` pour ajouter d'autres exclusions, ou en supprimer

## Sécurité

- S'assurer que le fichier `.netrc` a des permissions restreintes (`chmod 600`)
- Ne jamais partager ses identifiants FTP
- Vérifier que `.netrc` est bien listé dans le fichier `.gitignore`

## Licence

Ce projet est distribué sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus d'informations.

---

## Note de l'auteur

*Ce script était initialement un outil personnel que je n'avais pas prévu de partager publiquement. Néanmoins, s'il peut aider des personnes à déployer leurs projets via FTP sur des hébergements mutualisés, j'ai pensé qu'il pourrait être une bonne idée de le mettre à disposition. N'hésitez pas à l'adapter selon vos besoins.*

---