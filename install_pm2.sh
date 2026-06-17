#!/bin/bash

# En enkel funktion för att ställa en ja/nej-fråga
ask_yes_no() {
    while true; do
        read -p "$1 (j/n): " yn
        case $yn in
            [Jj]* ) return 0;; # Returnerar 0 (Sant/Ja)
            [Nn]* ) return 1;; # Returnerar 1 (Falskt/Nej)
            * ) echo "Vänligen svara med 'j' för ja eller 'n' för nej.";;
        esac
    done
}

echo "============================================="
echo "   Interaktivt installationsskript för PM2   "
echo "============================================="
echo ""

# Steg 1: Uppdatera systemet
if ask_yes_no "Steg 1: Vill du uppdatera systemets paketlistor (apt update & upgrade)?"; then
    echo "Uppdaterar systemet..."
    sudo apt update && sudo apt upgrade -y
    echo "Uppdatering klar."
    echo "---------------------------------------------"
else
    echo "Hoppar över systemuppdatering."
    echo "---------------------------------------------"
fi

# Steg 2: Installera Node.js och npm
if ask_yes_no "Steg 2: Vill du installera Node.js och npm?"; then
    echo "Installerar Node.js och npm..."
    sudo apt install nodejs npm -y
    echo "Node.js och npm är installerade."
    echo "---------------------------------------------"
else
    echo "Hoppar över installation av Node.js/npm."
    echo "---------------------------------------------"
fi

# Steg 3: Installera PM2
if ask_yes_no "Steg 3: Vill du installera PM2 globalt via npm?"; then
    echo "Installerar PM2..."
    sudo npm install -g pm2
    echo "PM2 är installerat."
    echo "---------------------------------------------"
else
    echo "Hoppar över PM2-installation. (Avslutar skriptet då de följande stegen kräver PM2)"
    exit 0
fi

# Steg 4: Autostart vid uppstart
if ask_yes_no "Steg 4: Vill du konfigurera PM2 att starta automatiskt när servern startas om?"; then
    echo "Konfigurerar PM2 för autostart..."
    # Genererar och kör startup-skriptet för systemd kopplat till den nuvarande användaren
    sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u $USER --hp $HOME
    
    echo "Sparar den nuvarande (tomma) PM2-listan..."
    pm2 save
    echo "Autostart är konfigurerat!"
    echo "---------------------------------------------"
else
    echo "Hoppar över autostart-konfiguration."
    echo "---------------------------------------------"
fi

echo "============================================="
echo "   Installation och konfiguration är klar!   "
echo "============================================="
