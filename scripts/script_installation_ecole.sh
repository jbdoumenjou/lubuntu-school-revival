#!/bin/bash

# =============================================================================
# LUBUNTU SCHOOL REVIVAL - Script d'installation éducative
# =============================================================================
# 
# 🎓 PROJET    : https://github.com/jbdoumenjou/lubuntu-school-revival
# 📄 LICENCE   : GPL v3 - Logiciel libre pour l'éducation
# 🐛 SUPPORT   : https://github.com/jbdoumenjou/lubuntu-school-revival/issues
# 📖 DOCS      : https://github.com/jbdoumenjou/lubuntu-school-revival/blob/main/README.md
#
# Compatible  : Celeron 570, 1Go RAM, chipset SiS 771/671
# Système     : Lubuntu 18.04.6 LTS 32-bit
# Version     : 1.0 - Script idempotent (peut être relancé sans problème)
#
# Ce script transforme de vieux ordinateurs en postes éducatifs fonctionnels
# Conçu pour les écoles primaires françaises avec budgets limités
# 
# =============================================================================

echo "=========================================="
echo "  INSTALLATION ÉCOLE PRIMAIRE - LUBUNTU  "
echo "=========================================="
echo ""

# Vérification utilisateur root
if [[ $EUID -eq 0 ]]; then
   echo "❌ Ne pas exécuter ce script en tant que root"
   exit 1
fi

# Fichier de suivi des étapes
INSTALL_LOG="/home/$USER/.install-ecole.log"
touch "$INSTALL_LOG"

# Fonction pour vérifier si une étape est déjà faite
check_done() {
    grep -q "^$1$" "$INSTALL_LOG" 2>/dev/null
}

# Fonction pour marquer une étape comme terminée
mark_done() {
    if ! check_done "$1"; then
        echo "$1" >> "$INSTALL_LOG"
    fi
}

# =============================================================================
# 1. CONFIGURATION GRUB POUR RÉSOLUTION SiS 771/671
# =============================================================================

if ! check_done "grub_config"; then
    echo "🔧 Configuration résolution d'écran (chipset SiS)..."

    # Sauvegarde GRUB
    if [ ! -f /etc/default/grub.backup ]; then
        sudo cp /etc/default/grub /etc/default/grub.backup
    fi

    # Vérifier si déjà modifié
    if ! grep -q "vga=788 nomodeset" /etc/default/grub; then
        # Modification GRUB pour résolution 800x600 de base
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash vga=788 nomodeset"/' /etc/default/grub
        
        # Application changements GRUB
        sudo update-grub
        
        echo "✅ Configuration GRUB modifiée (vga=788 nomodeset)"
    else
        echo "✅ Configuration GRUB déjà présente"
    fi
    
    mark_done "grub_config"
else
    echo "✅ Configuration GRUB déjà effectuée"
fi

# =============================================================================
# 2. CONFIGURATION XORG POUR 1024x768
# =============================================================================

if ! check_done "xorg_config"; then
    echo "🖥️ Configuration Xorg pour résolution 1024x768..."

    # Création du dossier si nécessaire
    sudo mkdir -p /etc/X11/xorg.conf.d/

    if [ ! -f /etc/X11/xorg.conf.d/20-graphics.conf ]; then
        sudo tee /etc/X11/xorg.conf.d/20-graphics.conf > /dev/null <<EOF
Section "Device"
    Identifier "Graphics"
    Driver "vesa"
EndSection

Section "Screen"
    Identifier "Screen0"
    Device "Graphics"
    DefaultDepth 16
    SubSection "Display"
        Depth 16
        Modes "1024x768" "800x600" "640x480"
    EndSubSection
EndSection
EOF
        echo "✅ Configuration Xorg créée"
    else
        echo "✅ Configuration Xorg déjà présente"
    fi
    
    mark_done "xorg_config"
else
    echo "✅ Configuration Xorg déjà effectuée"
fi

# =============================================================================
# 3. DÉSACTIVER LA VEILLE (PROBLÈME SiS)
# =============================================================================

if ! check_done "disable_sleep"; then
    echo "⚡ Désactivation de la veille (chipset SiS)..."

    # Vérifier si déjà masqués
    if systemctl is-enabled sleep.target >/dev/null 2>&1; then
        sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
        echo "✅ Services de veille masqués"
    else
        echo "✅ Services de veille déjà masqués"
    fi
    
    mark_done "disable_sleep"
else
    echo "✅ Désactivation de la veille déjà effectuée"
fi

# =============================================================================
# 4. CONFIGURATION DNS ANTI-PUBLICITÉS
# =============================================================================

if ! check_done "dns_config"; then
    echo "🛡️ Configuration DNS avec blocage publicités..."

    # Sauvegarde configuration réseau
    if [ ! -f /etc/systemd/resolved.conf.backup ]; then
        sudo cp /etc/systemd/resolved.conf /etc/systemd/resolved.conf.backup
    fi

    # Vérifier si déjà configuré
    if ! grep -q "1.1.1.2" /etc/systemd/resolved.conf; then
        sudo tee /etc/systemd/resolved.conf > /dev/null <<EOF
[Resolve]
DNS=1.1.1.2#cloudflare-dns.com
DNS=1.0.0.2#cloudflare-dns.com
FallbackDNS=9.9.9.10#dns.quad9.net
DNSSEC=no
EOF
        echo "✅ DNS anti-publicités configuré"
    else
        echo "✅ DNS anti-publicités déjà configuré"
    fi
    
    mark_done "dns_config"
else
    echo "✅ Configuration DNS déjà effectuée"
fi

# =============================================================================
# 5. MISE À JOUR SYSTÈME
# =============================================================================

if ! check_done "system_update"; then
    echo "📦 Mise à jour du système..."

    sudo apt update
    sudo apt upgrade -y

    echo "✅ Système mis à jour"
    mark_done "system_update"
else
    echo "✅ Mise à jour système déjà effectuée"
fi

# =============================================================================
# 6. INSTALLATION APPLICATIONS ÉDUCATIVES
# =============================================================================

if ! check_done "edu_apps"; then
    echo "🎓 Installation des applications éducatives..."

    # Vérifier si déjà installées
    apps_to_install=""
    for app in gcompris-qt tuxmath tuxtype; do
        if ! dpkg -l | grep -q "^ii.*$app"; then
            apps_to_install="$apps_to_install $app"
        fi
    done

    if [ -n "$apps_to_install" ]; then
        sudo apt install -y $apps_to_install
        echo "✅ Applications éducatives installées"
    else
        echo "✅ Applications éducatives déjà installées"
    fi
    
    mark_done "edu_apps"
else
    echo "✅ Applications éducatives déjà installées"
fi

# =============================================================================
# 7. INSTALLATION BUREAUTIQUE
# =============================================================================

if ! check_done "office_apps"; then
    echo "📝 Installation bureautique..."

    # Vérifier LibreOffice
    office_to_install=""
    for app in libreoffice libreoffice-l10n-fr libreoffice-help-fr abiword gnumeric; do
        if ! dpkg -l | grep -q "^ii.*$app"; then
            office_to_install="$office_to_install $app"
        fi
    done

    if [ -n "$office_to_install" ]; then
        sudo apt install -y $office_to_install
        echo "✅ Suite bureautique installée"
    else
        echo "✅ Suite bureautique déjà installée"
    fi
    
    mark_done "office_apps"
else
    echo "✅ Suite bureautique déjà installée"
fi

# =============================================================================
# 8. APPLICATIONS SCIENCES ET DÉCOUVERTES
# =============================================================================

if ! check_done "science_apps"; then
    echo "🔬 Installation applications sciences..."

    science_to_install=""
    for app in stellarium marble; do
        if ! dpkg -l | grep -q "^ii.*$app"; then
            science_to_install="$science_to_install $app"
        fi
    done

    if [ -n "$science_to_install" ]; then
        sudo apt install -y $science_to_install
        echo "✅ Applications sciences installées"
    else
        echo "✅ Applications sciences déjà installées"
    fi
    
    mark_done "science_apps"
else
    echo "✅ Applications sciences déjà installées"
fi

# =============================================================================
# 9. APPLICATIONS CRÉATIVES ET MULTIMÉDIA
# =============================================================================

if ! check_done "creative_apps"; then
    echo "🎨 Installation applications créatives..."

    creative_to_install=""
    for app in tuxpaint tuxpaint-config vlc ubuntu-restricted-extras audacity; do
        if ! dpkg -l | grep -q "^ii.*$app"; then
            creative_to_install="$creative_to_install $app"
        fi
    done

    if [ -n "$creative_to_install" ]; then
        DEBIAN_FRONTEND=noninteractive sudo apt install -y $creative_to_install
        echo "✅ Applications créatives installées"
    else
        echo "✅ Applications créatives déjà installées"
    fi
    
    mark_done "creative_apps"
else
    echo "✅ Applications créatives déjà installées"
fi

# =============================================================================
# 10. NAVIGATEUR WEB
# =============================================================================

if ! check_done "firefox_esr"; then
    echo "🌐 Installation Firefox ESR..."

    # Vérifier si le dépôt Mozilla est déjà ajouté
    if [ ! -f /etc/apt/sources.list.d/mozilla.list ]; then
        # Ajout du dépôt Mozilla officiel
        wget -q -O - https://packages.mozilla.org/apt/repo-signing-key.gpg | sudo apt-key add -
        echo "deb https://packages.mozilla.org/apt mozilla main" | sudo tee /etc/apt/sources.list.d/mozilla.list
        
        # Mise à jour des dépôts
        sudo apt update
    fi

    # Vérifier si Firefox ESR est installé
    if ! dpkg -l | grep -q "^ii.*firefox-esr"; then
        sudo apt install -y firefox-esr
        echo "✅ Firefox ESR installé"
    else
        echo "✅ Firefox ESR déjà installé"
    fi

    # Configuration navigateur par défaut
    if ! update-alternatives --query x-www-browser | grep -q firefox-esr; then
        sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/firefox-esr 200
        echo "✅ Firefox ESR configuré par défaut"
    else
        echo "✅ Firefox ESR déjà configuré par défaut"
    fi
    
    mark_done "firefox_esr"
else
    echo "✅ Firefox ESR déjà installé et configuré"
fi

# =============================================================================
# 11. JEUX ÉDUCATIFS SUPPLÉMENTAIRES
# =============================================================================

if ! check_done "games_apps"; then
    echo "🎮 Installation jeux éducatifs..."

    games_to_install=""
    for app in kanagram childsplay; do
        if ! dpkg -l | grep -q "^ii.*$app"; then
            games_to_install="$games_to_install $app"
        fi
    done

    if [ -n "$games_to_install" ]; then
        sudo apt install -y $games_to_install
        echo "✅ Jeux éducatifs installés (Kanagram + Childsplay)"
    else
        echo "✅ Jeux éducatifs déjà installés"
    fi
    
    mark_done "games_apps"
else
    echo "✅ Jeux éducatifs déjà installés"
fi

# =============================================================================
# 12. OUTILS PRATIQUES ÉCOLE
# =============================================================================

if ! check_done "tools_apps"; then
    echo "🔧 Installation outils pratiques..."

    if ! dpkg -l | grep -q "^ii.*simple-scan"; then
        sudo apt install -y simple-scan
        echo "✅ Outils pratiques installés"
    else
        echo "✅ Outils pratiques déjà installés"
    fi
    
    mark_done "tools_apps"
else
    echo "✅ Outils pratiques déjà installés"
fi

# =============================================================================
# 13. SUPPORT TROUBLES DYS
# =============================================================================

if ! check_done "dys_support"; then
    echo "💡 Installation support troubles DYS..."

    dys_to_install=""
    for app in fonts-opendyslexic espeak espeak-data-fr festival festvox-fr-mbrola-fr1; do
        if ! dpkg -l | grep -q "^ii.*$app"; then
            dys_to_install="$dys_to_install $app"
        fi
    done

    if [ -n "$dys_to_install" ]; then
        sudo apt install -y $dys_to_install
        echo "✅ Support DYS installé"
    else
        echo "✅ Support DYS déjà installé"
    fi
    
    mark_done "dys_support"
else
    echo "✅ Support DYS déjà installé"
fi

# =============================================================================
# 14. PROGRAMMATION (SCRATCH)
# =============================================================================

if ! check_done "scratch_app"; then
    echo "💻 Installation Scratch..."

    if ! dpkg -l | grep -q "^ii.*scratch"; then
        sudo apt install -y scratch
        echo "✅ Scratch 1.4 installé (via APT)"
    else
        echo "✅ Scratch déjà installé"
    fi
    
    mark_done "scratch_app"
else
    echo "✅ Scratch déjà installé"
fi

# =============================================================================
# 15. CONFIGURATION UTILISATEUR
# =============================================================================

if ! check_done "user_config"; then
    echo "👤 Configuration utilisateur..."

    # Créer dossiers pour les élèves s'ils n'existent pas
    if [ ! -d "/home/$USER/Élèves" ]; then
        mkdir -p /home/$USER/Élèves
        echo "✅ Dossier Élèves créé"
    else
        echo "✅ Dossier Élèves déjà présent"
    fi

    if [ ! -d "/home/$USER/Travaux-communs" ]; then
        mkdir -p /home/$USER/Travaux-communs
        echo "✅ Dossier Travaux-communs créé"
    else
        echo "✅ Dossier Travaux-communs déjà présent"
    fi

    # Créer script lecture vocale sur le bureau s'il n'existe pas
    if [ ! -f "/home/$USER/Bureau/Lecture-vocale.sh" ]; then
        cat > /home/$USER/Bureau/Lecture-vocale.sh << 'EOF'
#!/bin/bash
# Script de lecture vocale pour élèves

# Interface graphique simple
texte=$(zenity --text-info --editable --title="Lecture Vocale" --text="Tapez votre texte ici...")

if [ $? -eq 0 ] && [ -n "$texte" ]; then
    espeak -v french -s 120 "$texte"
fi
EOF
        chmod +x /home/$USER/Bureau/Lecture-vocale.sh
        echo "✅ Script lecture vocale créé"
    else
        echo "✅ Script lecture vocale déjà présent"
    fi
    
    mark_done "user_config"
else
    echo "✅ Configuration utilisateur déjà effectuée"
fi

# =============================================================================
# 16. PAGE D'ACCUEIL ÉDUCATIVE
# =============================================================================

if ! check_done "homepage"; then
    echo "🏠 Création page d'accueil éducative..."

    if [ ! -f "/home/$USER/Bureau/page-accueil-ecole.html" ]; then
        cat > /home/$USER/Bureau/page-accueil-ecole.html << 'EOF'
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>École Primaire - Sites Éducatifs</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f0f0f0; }
        h1 { color: #0066cc; text-align: center; }
        h2 { color: #333; background-color: #e6e6e6; padding: 8px; border-left: 4px solid #0066cc; }
        .search { text-align: center; margin: 20px 0; background-color: white; padding: 15px; border: 1px solid #ccc; }
        .search input { width: 300px; padding: 8px; font-size: 14px; }
        .search button { background: #0066cc; color: white; padding: 8px 15px; border: none; cursor: pointer; }
        .category { background: white; margin: 15px 0; padding: 15px; border: 1px solid #ccc; }
        .sites { margin: 10px 0; }
        .site { display: inline-block; width: 200px; margin: 8px; padding: 12px; background: #f9f9f9; border: 1px solid #ddd; text-align: center; vertical-align: top; }
        .site a { text-decoration: none; color: #0066cc; font-weight: bold; }
        .site a:hover { color: #004499; }
        .essential { background: #ffeeee; border: 2px solid #cc0000; }
        .essential a { color: #cc0000; }
        small { color: #666; display: block; margin-top: 5px; }
    </style>
</head>
<body>
    <h1>École Primaire - Sites Éducatifs</h1>
    
    <div class="search">
        <form action="https://www.qwantjunior.com" method="get">
            <input type="text" name="q" placeholder="Rechercher avec Qwant Junior...">
            <button type="submit">Rechercher</button>
        </form>
    </div>
    
    <div class="category">
        <h2>Sites Essentiels</h2>
        <div class="sites">
            <div class="site essential">
                <a href="https://www.logicieleducatif.fr" target="_blank">Logiciel Éducatif<small>Jeux éducatifs tous niveaux</small></a>
            </div>
            <div class="site essential">
                <a href="https://www.iletaitunehistoire.com" target="_blank">Il était une histoire<small>Histoires et contes lus</small></a>
            </div>
            <div class="site essential">
                <a href="https://lirecouleur.arkaline.fr" target="_blank">LireCouleur<small>Aide lecture DYS</small></a>
            </div>
        </div>
    </div>
    
    <div class="category">
        <h2>Mathématiques</h2>
        <div class="sites">
            <div class="site">
                <a href="https://www.maths-et-tiques.fr" target="_blank">Maths et Tiques<small>Cours et exercices</small></a>
            </div>
            <div class="site">
                <a href="https://calculatice.ac-lille.fr" target="_blank">Calculatice<small>Calcul mental officiel</small></a>
            </div>
            <div class="site">
                <a href="https://www.jeuxmaths.fr" target="_blank">Jeux Maths<small>Jeux éducatifs mathématiques</small></a>
            </div>
        </div>
    </div>
    
    <div class="category">
        <h2>Lecture et Littérature</h2>
        <div class="sites">
            <div class="site">
                <a href="https://enfants.bnf.fr" target="_blank">BnF Enfants<small>Bibliothèque Nationale</small></a>
            </div>
            <div class="site">
                <a href="https://www.conte-moi.net" target="_blank">Conte-moi<small>Contes du monde</small></a>
            </div>
        </div>
    </div>
    
    <div class="category">
        <h2>Géographie et Sciences</h2>
        <div class="sites">
            <div class="site">
                <a href="https://www.geoportail.gouv.fr" target="_blank">Géoportail<small>Cartes interactives</small></a>
            </div>
            <div class="site">
                <a href="https://www.jeux-geographiques.com" target="_blank">Jeux Géographiques<small>Quiz géographie</small></a>
            </div>
        </div>
    </div>
</body>
</html>
EOF
        echo "✅ Page d'accueil éducative créée"
    else
        echo "✅ Page d'accueil éducative déjà présente"
    fi
    
    mark_done "homepage"
else
    echo "✅ Page d'accueil éducative déjà créée"
fi

# =============================================================================
# 17. NETTOYAGE SYSTÈME
# =============================================================================

if ! check_done "cleanup"; then
    echo "🧹 Nettoyage système..."

    # Supprimer paquets inutiles
    sudo apt autoremove -y
    sudo apt autoclean

    # Nettoyer dossier crash
    sudo rm -rf /var/crash/*

    echo "✅ Nettoyage terminé"
    mark_done "cleanup"
else
    echo "✅ Nettoyage déjà effectué"
fi

# =============================================================================
# 18. SCRIPT DE MAINTENANCE
# =============================================================================

if ! check_done "maintenance_script"; then
    echo "📝 Création script de maintenance..."

    if [ ! -f "/home/$USER/Bureau/Maintenance-ecole.sh" ]; then
        cat > /home/$USER/Bureau/Maintenance-ecole.sh << 'EOF'
#!/bin/bash
echo "=== MAINTENANCE ÉCOLE ==="

# Nettoyage système
sudo apt autoremove -y
sudo apt autoclean
sudo rm -rf /var/crash/*

# Nettoyage cache navigateur
rm -rf ~/.cache/mozilla/firefox/*/cache2/* 2>/dev/null

# Vider corbeille
rm -rf ~/.local/share/Trash/files/* 2>/dev/null

echo "✅ Maintenance terminée !"
EOF
        chmod +x /home/$USER/Bureau/Maintenance-ecole.sh
        echo "✅ Script de maintenance créé"
    else
        echo "✅ Script de maintenance déjà présent"
    fi
    
    mark_done "maintenance_script"
else
    echo "✅ Script de maintenance déjà créé"
fi

# =============================================================================
# 19. RÉSUMÉ ET INSTRUCTIONS FINALES
# =============================================================================

echo ""
echo "=========================================="
echo "  INSTALLATION TERMINÉE AVEC SUCCÈS !    "
echo "=========================================="
echo ""
echo "📋 RÉSUMÉ DES MODIFICATIONS :"
echo ""
echo "🔧 Configuration système :"
echo "   • GRUB : résolution vga=788 nomodeset"
echo "   • Xorg : support 1024x768 pour chipset SiS"
echo "   • Veille : désactivée (problème SiS)"
echo "   • DNS : anti-publicités configuré"
echo ""
echo "📚 Applications installées :"
echo "   • GCompris, TuxMath, TuxType (éducatif)"
echo "   • LibreOffice + AbiWord/Gnumeric (bureautique)"
echo "   • Stellarium, Marble (sciences)"
echo "   • TuxPaint, Audacity (créatif)"
echo "   • Firefox ESR (navigateur récent)"
echo "   • Kanagram, Childsplay (jeux éducatifs)"
echo "   • Simple-scan (numérisation)"
echo "   • Support DYS : OpenDyslexic + eSpeak"
echo "   • Scratch 1.4 (programmation, via APT)"
echo ""
echo "🏠 Fichiers créés :"
echo "   • /home/$USER/Bureau/page-accueil-ecole.html"
echo "   • /home/$USER/Bureau/Lecture-vocale.sh"
echo "   • /home/$USER/Bureau/Maintenance-ecole.sh"
echo "   • /home/$USER/Élèves/ (dossier élèves)"
echo ""
echo "⚠️  REDÉMARRAGE OBLIGATOIRE pour :"
echo "   • Nouvelle résolution d'écran"
echo "   • Configuration DNS"
echo "   • Désactivation de la veille"
echo ""
echo "🔄 Commande de redémarrage :"
echo "   sudo reboot"
echo ""
echo "📖 Après redémarrage :"
echo "   • Configurer Firefox ESR :"
echo "     - Page d'accueil : https://www.qwantjunior.com"
echo "     - Installer uBlock Origin depuis about:addons"
echo "     - Installer Read Aloud (aide DYS)"
echo "     - Ou utiliser page locale : file:///home/$USER/Bureau/page-accueil-ecole.html"
echo "   • Tester résolution (doit être 1024x768 ou 800x600)"
echo "   • Vérifier blocage pub DNS (sites sans publicités)"
echo ""
echo "✅ Prêt pour clonage avec Clonezilla !"
echo ""
echo "📊 Log des étapes : $INSTALL_LOG"
echo "🔄 Script idempotent : peut être relancé sans problème"
echo ""
