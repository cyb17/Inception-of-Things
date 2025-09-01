
#!/bin/bash

# ------------------------------------------------------------------------------
# 🎨 COULEURS ET CONFIGS
# ------------------------------------------------------------------------------
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
BREAK_LINE="${GREEN}================================================================================${NC}"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
set -e

# ------------------------------------------------------------------------------
# 🔧 FONCTIONS
# ------------------------------------------------------------------------------
install_if_missing() {
    if ! which "$1" > /dev/null 2>&1; then
        echo "📦 ${YELLOW}Installation de $1...${NC}"
        sudo apt install -y "$1"
    else
        echo "✅ ${YELLOW}$1 déjà installé${NC}"
    fi
}

print_section() {
    echo "\n$BREAK_LINE"
    echo "🔧 ${YELLOW}$1${NC}"
}

append_if_missing() {
    local line="$1"
    local file="$2"
    grep -qxF "$line" "$file" || echo "$line" >> "$file"
}

# ------------------------------------------------------------------------------
# 🔁 MISE À JOUR DES PAQUETS
# ------------------------------------------------------------------------------
print_section "Mise à jour des paquets"
sudo apt update -y && sudo apt upgrade -y

# ------------------------------------------------------------------------------
# 📦 INSTALLATION DES OUTILS DE BASE
# ------------------------------------------------------------------------------
print_section "Installation des outils de base"
for pkg in curl wget git vim unzip tar gnupg zsh; do
    install_if_missing "$pkg"
done

# ------------------------------------------------------------------------------
# 📦 INSTALLATION SSH SERVER
# ------------------------------------------------------------------------------
print_section "Installation de ssh server"
if ! dpkg -s openssh-server > /dev/null 2>&1; then
	echo "📦 ${YELLOW}Installation de ssh server...${NC}"
        sudo apt install -y openssh-server
    else
        echo "✅ ${YELLOW}openssh-server déjà installé${NC}"
    fi

# ------------------------------------------------------------------------------
# ⚙️ CONFIGURATION DE VIM
# ------------------------------------------------------------------------------
print_section "Configuration de Vim"
cat << 'EOF' > ~/.vimrc
"===========================================================================================
"						 ---------------------
"					    | parametres basiques |
"						 ---------------------

set encoding=utf-8
set nocompatible		" désactive compatibilité vi
syntax on				" coloration syntaxique
set autoindent			" indentation automatique
set number 				" afficher les numéros de lignes
set mouse=a 			" activer la souris
set shiftwidth=4		" nombre d'espaces pour une tabulation
set tabstop=4 			" utiliser tab au lieu d'espace
set scrolloff=3			" marge de 3 lignes avant ou après le curseur
set incsearch 			" recherche incrémentale (affiche pendant la frappe)
set ignorecase 			" recherche insensible à la casse
set ruler 				" afficher ligne/colonne en bas
set backspace=2			" autorise backspace même en début de ligne
colorscheme desert		" theme desert
"===========================================================================================
EOF

# ------------------------------------------------------------------------------
# 💻 INSTALLATION DE OH MY ZSH
# ------------------------------------------------------------------------------
print_section "Installation de Oh My Zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ ${YELLOW}Oh My Zsh déjà installé${NC}"
fi

# ------------------------------------------------------------------------------
# 🔌 INSTALLATION DES PLUGINS ZSH
# ------------------------------------------------------------------------------
print_section "Installation des plugins Zsh"

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
fi

# ------------------------------------------------------------------------------
# ⚙️ CONFIGURATION DE .zshrc
# ------------------------------------------------------------------------------
print_section "Configuration de .zshrc"

# Activer les plugins
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

# Ajout des alias perso si manquants
append_if_missing 'alias cl="clear"' ~/.zshrc
append_if_missing 'alias ls="ls --color=auto"' ~/.zshrc
append_if_missing 'alias rmf="rm -rf"' ~/.zshrc

# ------------------------------------------------------------------------------
# 🐚 ZSH COMME SHELL PAR DÉFAUT
# ------------------------------------------------------------------------------
print_section "Définir Zsh comme shell par défaut"
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
    echo "✅ ${YELLOW}Zsh est maintenant le shell par défaut${NC}"
else
    echo "✅ ${YELLOW}Zsh est déjà le shell par défaut${NC}"
fi

# ------------------------------------------------------------------------------
# 📦 INSTALLATION DE VAGRANT
# ------------------------------------------------------------------------------
print_section "Installation de Vagrant"
if ! which vagrant > /dev/null 2>&1; then
    wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install -y vagrant
    echo "✅ ${YELLOW}Vagrant installé avec succès${NC}"
else
    echo "✅ ${YELLOW}Vagrant déjà installé${NC}"
fi

# ------------------------------------------------------------------------------
# 🐳 INSTALLATION DE K3s
# ------------------------------------------------------------------------------
print_section "Installation de K3s (Server)"
if ! which k3s > /dev/null 2>&1; then
    curl -sfL https://get.k3s.io | sh -
    echo "✅ ${YELLOW}K3s installé avec succès${NC}"
else
    echo "✅ ${YELLOW}K3s déjà installé${NC}"
fi

# ------------------------------------------------------------------------------
# 📦 INSTALLATION DE VIRTUALBOX
# ------------------------------------------------------------------------------
print_section "Installation de VirtualBox"

if ! which virtualbox > /dev/null 2>&1; then
    echo "📦 ${YELLOW}Ajout du dépôt VirtualBox...${NC}"

	# Supprimer l'ancienne clé si elle existe
	sudo rm -f /usr/share/keyrings/virtualbox.gpg

	# Télécharger et installer la bonne clé GPG (Oracle VBOX 2016)
	wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | \
		gpg --dearmor | sudo tee /usr/share/keyrings/virtualbox.gpg > /dev/null

	# Écrire proprement la source VirtualBox pour Debian Trixie
	DISTRO_CODENAME=$(lsb_release -cs)
	echo "deb [arch=amd64 signed-by=/usr/share/keyrings/virtualbox.gpg] https://download.virtualbox.org/virtualbox/debian $DISTRO_CODENAME contrib" | \
		sudo tee /etc/apt/sources.list.d/virtualbox.list > /dev/null

	# Mise à jour du cache APT
	sudo apt update
    sudo apt install -y virtualbox-7.1

    echo "✅ ${YELLOW}VirtualBox installé avec succès${NC}"
else
    echo "✅ ${YELLOW}VirtualBox déjà installé${NC}"
fi

# ------------------------------------------------------------------------------
# ✅ FIN
# ------------------------------------------------------------------------------
echo -e "\n🎉 ${GREEN}Installation terminée ! Relance ton terminal pour profiter de Vim + Oh My Zsh.${NC}"
