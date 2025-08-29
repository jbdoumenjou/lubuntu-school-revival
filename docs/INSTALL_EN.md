# 📖 Installation Guide - English

## Prerequisites

- **System**: Fresh Lubuntu 18.04.6 LTS 32-bit installation
- **Hardware**: Celeron 570, 1GB RAM minimum, SiS 771/671 chipset
- **Access**: Internet connection, sudo rights

## Step-by-step installation

### 1. Download the project

```bash
# Clone the repository
git clone https://github.com/jbdoumenjou/lubuntu-school-revival.git
cd lubuntu-school-revival

# Or download the script directly
wget https://raw.githubusercontent.com/jbdoumenjou/lubuntu-school-revival/main/scripts/script_installation_ecole.sh
```

### 2. Run the installation

```bash
# Make the script executable
chmod +x scripts/script_installation_ecole.sh

# Launch installation (NOT as root!)
./scripts/script_installation_ecole.sh
```

⚠️ **IMPORTANT**: NEVER run the script with `sudo` or as root!

### 3. Mandatory reboot

```bash
sudo reboot
```

### 4. Post-installation checks

After reboot, verify:

- **Screen resolution**: 1024x768 or 800x600
- **Applications**: Menu → Education / Science / Office
- **Homepage**: `~/Bureau/page-accueil-ecole.html`
- **Voice reading**: `~/Bureau/Lecture-vocale.sh`

## Firefox configuration

1. **Homepage**: https://www.qwantjunior.com
2. **Recommended extensions**:
   - uBlock Origin (ad blocking)
   - Read Aloud (DYS assistance)

## Maintenance

Run regularly:
```bash
~/Bureau/Maintenance-ecole.sh
```

## Troubleshooting

### Display issues
```bash
# Check Xorg configuration
ls /etc/X11/xorg.conf.d/20-graphics.conf
```

### DNS issues
```bash
# Check DNS configuration
cat /etc/systemd/resolved.conf
```

### Script stuck
```bash
# See completed steps
cat ~/.install-ecole.log
```

## Clonezilla cloning

After successful installation, the system is ready for cloning:

1. Create a Clonezilla image
2. Deploy on other similar machines
3. Each clone will be identical and functional

## Support

- 🐛 [Report a bug](https://github.com/jbdoumenjou/lubuntu-school-revival/issues)
- 💬 [Discussion forum](https://github.com/jbdoumenjou/lubuntu-school-revival/discussions)