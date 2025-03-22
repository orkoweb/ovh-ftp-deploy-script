# OVH FTP Deploy Script

---

Ce script permet de déployer un projet via FTP sur un serveur OVH mutualisé en utilisant `lftp`.

---

## Prérequis

`lftp` doit être installé sur votre système pour que le script fonctionne correctement. Voici comment l'installer (macOS) :

### Via Homebrew :
```sh
brew install lftp
```

## Installation

1. **Créer un fichier `.netrc`** dans son répertoire utilisateur `~/` (macOS), à la main ou via :
   ```sh
   touch ~/.netrc
   chmod 600 ~/.netrc
   ```
   
   Un fichier d'exemple `netrc.example` est disponible dans ce dépôt.

2. Y ajouter les informations de connexion FTP et enregistrer
   ```txt
   machine example.your-hosting.com
   login VOTRE_LOGIN
   password VOTRE_MOTDEPASSE
   ```

   > **⚠️ Sécurité** : ne versionnez jamais le fichier `.netrc` contenant vos identifiants réels. Ce fichier doit rester uniquement sur votre machine locale.

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

- Assurez-vous que le fichier `.netrc` a des permissions restreintes (`chmod 600`)
- Ne partagez jamais vos identifiants FTP
- Vérifiez que `.netrc` est bien dans votre `.gitignore`

## Note

*Ce script était initialement un outil personnel que je n'avais pas prévu de partager publiquement. Il reste simple et sans fioritures, mais il fonctionne efficacement pour mes besoins. Néanmoins, s'il peut aider des personnes à déployer leurs projets via FTP sur des hébergements mutualisés, j'ai pensé qu'il pourrait être une bonne idée de le mettre à disposition. N'hésitez pas à l'adapter à vos propres besoins.*

## Licence

Ce projet est distribué sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus d'informations.

---