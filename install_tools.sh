#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
BREAK_LINE="${GREEN}================================================================================${NC}"

set -e

echo -e "🔧 ${YELLOW}Mise à jour des paquets...${NC}"
sudo apt update -y && sudo apt upgrade -y
echo -e "$BREAK_LINE"

echo -e "📦 ${YELLOW}Installation des outils de base...${NC}"
sudo apt install -y \
    curl wget git vim unzip tar gnupg zsh
echo -e "$BREAK_LINE"

# ------------------------------------------------------------------------------
# VIM CONFIGURATION
# ------------------------------------------------------------------------------
echo -e "⚙️  ${YELLOW}Configuration de Vim...${NC}"
cat << 'EOF' > ~/.vimrc
"===========================================================================================
"						 ---------------------
"					    | parametres basiques |
"						 ---------------------

set encoding=utf-8
set nocompatible		"desactive compatibilite vi
syntax on				"coloration syntaxique
set autoindent			"indentation automatique
set number 				"activer le nm de ligne
set mouse=a 			"activer la souris
set shiftwidth=4		"nbr d'espace pour 1 tabulation
set tabstop=4 			"utiliser tab aulieu d'espace
set scrolloff=3			"marge de 3lignes avant ou apres curseur
set incsearch 			"highlight le mots recheche
set ignorecase 			"recherche insensible a la case
set ruler 				"affichage filename, ligne, colonne en bas
set backspace=2			"permet supp caractere precedent meme endebut deligne
"colorscheme lunaperche	"changer le theme vim en /lunaperche/

"===========================================================================================
EOF
echo -e "$BREAK_LINE"

# ------------------------------------------------------------------------------
# OH MY ZSH INSTALLATION
# ------------------------------------------------------------------------------
echo -e "📦 ${YELLOW}Installation de Oh My Zsh...${NC}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo -e "✅ ${YELLOW}Oh My Zsh déjà installé${NC}"
fi
echo -e "$BREAK_LINE"

echo -e "📦 ${YELLOW}Installation des plugins Zsh...${NC}"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
fi
# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
fi
echo -e "$BREAK_LINE"

# ------------------------------------------------------------------------------
# CONFIGURATION DE .zshrc
# ------------------------------------------------------------------------------
echo -e "⚙️  ${YELLOW}Configuration de .zshrc...${NC}"
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

cat << 'EOF' >> ~/.zshrc

# ================= ALIAS PERSO =================
alias cl="clear"
alias ls="ls --color=auto"
alias rmf="rm -rf"
# ===============================================
EOF
echo -e "$BREAK_LINE"

# ------------------------------------------------------------------------------
# SHELL PAR DÉFAUT = ZSH
# ------------------------------------------------------------------------------
echo -e "⚙️  ${YELLOW}Passage à Zsh par défaut...${NC}"
chsh -s $(which zsh)
echo -e "$BREAK_LINE"

# ------------------------------------------------------------------------------
# INSTALLATION DE VAGRANT
# ------------------------------------------------------------------------------
echo -e "${YELLOW}Installation de Vagrant...${NC}"
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vagrant
echo "${YELLOW}✅ Vagrant installé avec succès${NC}"
echo -e ${BREAK_LINE}

# ------------------------------------------------------------------------------
# INSTALLATION DE K3s
# ------------------------------------------------------------------------------
echo -e "${YELLOW}Installation de K3s Server...${NC}"
curl -sfL https://get.k3s.io | sh - 
echo "${YELLOW}✅ K3s installé avec succès${NC}"
echo -e ${BREAK_LINE}


echo -e "🎉 ${YELLOW}Installation terminée ! Relance ton terminal pour profiter de Vim + Oh My Zsh.${NC}"

