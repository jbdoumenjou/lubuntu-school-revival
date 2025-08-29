# 📖 Guide d'installation - Français

## Prérequis

- **Système** : Lubuntu 18.04.6 LTS 32-bit fraîchement installé
- **Matériel** : Celeron 570, 1Go RAM minimum, chipset SiS 771/671
- **Accès** : Connexion internet, droits sudo

## Installation pas-à-pas

### 1. Télécharger le projet

```bash
# Cloner le dépôt
git clone https://github.com/jbdoumenjou/lubuntu-school-revival.git
cd lubuntu-school-revival

# Ou télécharger directement le script
wget https://raw.githubusercontent.com/jbdoumenjou/lubuntu-school-revival/main/scripts/script_installation_ecole.sh
```

### 2. Exécuter l'installation

```bash
# Rendre le script exécutable
chmod +x scripts/script_installation_ecole.sh

# Lancer l'installation (PAS en root !)
./scripts/script_installation_ecole.sh
```

⚠️ **IMPORTANT** : N'exécutez JAMAIS le script avec `sudo` ou en tant que root !

### 3. Redémarrage obligatoire

```bash
sudo reboot
```

### 4. Vérifications post-installation

Après redémarrage, vérifiez :

- **Résolution d'écran** : 1024x768 ou 800x600
- **Applications** : Menu → Éducation / Sciences / Bureautique
- **Page d'accueil** : `~/Bureau/page-accueil-ecole.html`
- **Lecture vocale** : `~/Bureau/Lecture-vocale.sh`

## Configuration Firefox

1. **Page d'accueil** : https://www.qwantjunior.com
2. **Extensions recommandées** :
   - uBlock Origin (blocage publicités)
   - Read Aloud (aide DYS)

## Maintenance

Exécutez régulièrement :
```bash
~/Bureau/Maintenance-ecole.sh
```

## Dépannage

### Problème d'affichage
```bash
# Vérifier la configuration Xorg
ls /etc/X11/xorg.conf.d/20-graphics.conf
```

### Problème DNS
```bash
# Vérifier la configuration DNS
cat /etc/systemd/resolved.conf
```

### Script bloqué
```bash
# Voir les étapes déjà effectuées
cat ~/.install-ecole.log
```

## Clonage avec Clonezilla

Après installation réussie, le système est prêt pour clonage :

1. Créer une image Clonezilla
2. Déployer sur d'autres machines similaires
3. Chaque clone sera identique et fonctionnel

## Support

- 🐛 [Signaler un bug](https://github.com/jbdoumenjou/lubuntu-school-revival/issues)
- 💬 [Forum de discussion](https://github.com/jbdoumenjou/lubuntu-school-revival/discussions)