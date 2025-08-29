# 🖥️ Lubuntu School Revival

**Redonnez vie aux anciens ordinateurs pour l'éducation ! / Revive old computers for education!**

Un script d'installation automatisé pour transformer de vieux ordinateurs (Celeron 570, 1Go RAM, chipset SiS) en postes éducatifs fonctionnels avec Lubuntu 18.04 LTS.

*An automated installation script to transform old computers (Celeron 570, 1GB RAM, SiS chipset) into functional educational workstations with Lubuntu 18.04 LTS.*

---

## 🎯 Objectif / Goal

Ce projet aide les écoles françaises à réutiliser des ordinateurs obsolètes en installant automatiquement un environnement éducatif complet, optimisé pour les contraintes matérielles anciennes.

*This project helps French schools reuse obsolete computers by automatically installing a complete educational environment, optimized for old hardware constraints.*

## 🔧 Matériel supporté / Supported Hardware

- **Processeur** : Celeron 570 ou équivalent
- **Mémoire** : 1 Go RAM minimum  
- **Chipset** : SiS 771/671 (problèmes graphiques résolus)
- **Système** : Lubuntu 18.04.6 LTS 32-bit

## 📚 Applications installées / Installed Applications

### Éducatif / Educational
- **GCompris** - Suite éducative complète
- **TuxMath** - Mathématiques ludiques
- **TuxType** - Apprentissage du clavier
- **Kanagram** - Jeux de lettres
- **Childsplay** - Activités pour jeunes enfants

### Sciences
- **Stellarium** - Planétarium 3D
- **Marble** - Atlas mondial interactif

### Bureautique / Office
- **LibreOffice** - Suite bureautique complète
- **AbiWord/Gnumeric** - Alternatives légères

### Créatif / Creative
- **TuxPaint** - Dessin pour enfants
- **Audacity** - Édition audio

### Support troubles DYS
- **OpenDyslexic** - Police spécialisée
- **eSpeak** - Synthèse vocale française

## 🚀 Installation rapide / Quick Installation

```bash
# Télécharger le script
wget https://raw.githubusercontent.com/jbdoumenjou/lubuntu-school-revival/main/scripts/script_installation_ecole.sh

# Rendre exécutable
chmod +x script_installation_ecole.sh

# Exécuter (PAS en root !)
./scripts/script_installation_ecole.sh
```

⚠️ **Important** : Ne PAS exécuter en tant que root. Le script vous demandera le mot de passe sudo quand nécessaire.

## 🔄 Fonctionnalités / Features

- ✅ **Idempotent** - Peut être relancé sans problème
- ✅ **Optimisé SiS** - Résout les problèmes de chipset SiS 771/671
- ✅ **DNS anti-pub** - Cloudflare DNS avec blocage publicitaire
- ✅ **Support DYS** - Outils pour troubles de l'apprentissage
- ✅ **Page d'accueil** - Sites éducatifs présélectionnés
- ✅ **Maintenance** - Script de nettoyage automatisé

## 📖 Documentation complète

- 🇫🇷 [Guide d'installation français](docs/INSTALL_FR.md)
- 🇬🇧 [English installation guide](docs/INSTALL_EN.md)
- 🤝 [Guide de contribution](CONTRIBUTING.md)

## 🏫 Contexte éducatif / Educational Context

Ce projet est né de la nécessité d'équiper des classes primaires avec des budgets limités. Les ordinateurs Celeron 570 avec 1Go de RAM étaient considérés comme inutilisables avec les systèmes modernes.

*This project was born from the need to equip primary classrooms with limited budgets. Celeron 570 computers with 1GB RAM were considered unusable with modern systems.*

**Résultat** : Des postes fonctionnels pour l'apprentissage numérique !

## 🤝 Contribuer / Contributing

Nous encourageons les contributions de la communauté éducative !

- 🐛 Signaler des bugs
- 💡 Proposer des améliorations
- 📝 Améliorer la documentation
- 🌍 Traduire le projet

Voir [CONTRIBUTING.md](CONTRIBUTING.md) pour les détails.

## 📄 Licence / License

Ce projet est sous licence GPL v3 pour garantir qu'il reste libre et ouvert pour l'éducation.

*This project is licensed under GPL v3 to ensure it remains free and open for education.*

Voir [LICENSE](LICENSE) pour les détails complets.

## 🎉 Remerciements / Acknowledgments

- Communauté éducative française
- Développeurs des logiciels éducatifs libres
- Équipe Lubuntu pour la compatibilité 32-bit

---

**Ensemble, redonnons vie aux anciens ordinateurs pour l'éducation ! 🚀**

*Together, let's revive old computers for education! 🚀*