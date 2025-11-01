
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
    if ! dpkg -s "$1" > /dev/null 2>&1; then
        echo -e "📦 ${YELLOW}Installation de $1...${NC}"
        sudo apt install -y "$1"
    else
        echo -e "✅ ${YELLOW}$1 déjà installé${NC}"
    fi
}

print_section() {
    echo -e "\n$BREAK_LINE"
    echo -e "${YELLOW}$1${NC}"
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
for pkg in curl wget git vim openssh-server gnupg zsh; do
    install_if_missing "$pkg"
done

# ------------------------------------------------------------------------------
# 📦 INSTALLATION DE VAGRANT
# ------------------------------------------------------------------------------
print_section "Installation de Vagrant"
if ! which vagrant > /dev/null 2>&1; then
    wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install -y vagrant
    echo -e "✅ ${YELLOW}Vagrant installé avec succès${NC}"
else
    echo -e "✅ ${YELLOW}Vagrant déjà installé${NC}"
fi

# ------------------------------------------------------------------------------
# 📦 INSTALLATION DE VIRTUALBOX
# ------------------------------------------------------------------------------
print_section "Installation de VirtualBox"

if ! which virtualbox > /dev/null 2>&1; then
    echo -e "📦 ${YELLOW}Ajout du dépôt VirtualBox...${NC}"

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

    echo -e "✅ ${YELLOW}VirtualBox installé avec succès${NC}"
else
    echo -e "✅ ${YELLOW}VirtualBox déjà installé${NC}"
fi

# ------------------------------------------------------------------------------
# 📦 INSTALLATION DE DOCKER
# ------------------------------------------------------------------------------
print_section "Installation de Docker"

if ! which docker > /dev/null 2>&1; then
    curl -fsSL https://get.docker.com | sh
    sudo usermod -aG docker $USER
    echo -e "✅ ${YELLOW}Docker installé avec succès${NC}"
else
    echo -e "✅ ${YELLOW}Docker déjà installé${NC}"
fi

# ------------------------------------------------------------------------------
# 📦 INSTALLATION DE K3D
# ------------------------------------------------------------------------------
print_section "Installation de K3D"

if ! which k3d > /dev/null 2>&1; then
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
    echo -e "✅ ${YELLOW}K3d installé avec succès${NC}"
else
    echo -e "✅ ${YELLOW}K3d déjà installé${NC}"
fi

# ------------------------------------------------------------------------------
# 📦 INSTALLATION DE kubectl
# ------------------------------------------------------------------------------
print_section "Installation de kubectl"

if ! which kubectl > /dev/null 2>&1; then
    curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
    echo -e "✅ ${YELLOW}kubectl installé avec succès${NC}"
else
    echo -e "✅ ${YELLOW}kubectl déjà installé${NC}"
fi

# ------------------------------------------------------------------------------
# 📦 INSTALLATION D'ARGOCD CLI
# ------------------------------------------------------------------------------
print_section "Installation de ArgoCD CLI"

if ! which argocd > /dev/null 2>&1; then
    ARGOCD_VERSION=$(curl -s https://api.github.com/repos/argoproj/argo-cd/releases/latest | grep tag_name | cut -d '"' -f 4)
    curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-amd64
    chmod +x argocd-linux-amd64
    sudo mv argocd-linux-amd64 /usr/local/bin/argocd
    echo -e "✅ ${YELLOW}ArgoCD CLI installé avec succès${NC}"
else
    echo -e "✅ ${YELLOW}ArgoCD CLI déjà installé${NC}"
fi

# ------------------------------------------------------------------------------
# 📦 INSTALLATION DE OH MY ZSH
# ------------------------------------------------------------------------------
print_section "Installation de Oh My Zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo -e "✅ ${YELLOW}Oh My Zsh installé avec succès${NC}"
else
    echo -e "✅ ${YELLOW}Oh My Zsh déjà installé${NC}"
fi

# ------------------------------------------------------------------------------
# 📦 INSTALLATION DES PLUGINS OH MY ZSH
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
# 📦 INSTALLATION DE HELM
# ------------------------------------------------------------------------------
print_section "Installation de Helm"

if ! which helm > /dev/null 2>&1; then
	curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    echo -e "✅ ${YELLOW}Helm installé avec succès${NC}"
else
    echo -e "✅ ${YELLOW}Helm déjà installé${NC}"
fi

# ------------------------------------------------------------------------------
# 📦 INSTALLATION D'UNE UI LEGER
# ------------------------------------------------------------------------------
print_section "Installation de lightdm UI"

if ! dpkg -l | grep lightdm > /dev/null 2>&1; then
	sudo apt install lightdm -y
    echo -e "✅ ${YELLOW}lightdm installé avec succès${NC}"
else
    echo -e "✅ ${YELLOW}lightdm déjà installé${NC}"
fi

# ------------------------------------------------------------------------------
# ⚙️  CONFIGURATION DE .zshrc
# ------------------------------------------------------------------------------
print_section "Configuration de .zshrc"

# activer les plugins
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
# ajout des alias perso si manquants
append_if_missing 'alias cl="clear"' ~/.zshrc
append_if_missing 'alias ls="ls --color=auto"' ~/.zshrc
append_if_missing 'alias rmf="rm -rf"' ~/.zshrc
append_if_missing 'alias k="kubectl"' ~/.zshrc

# ------------------------------------------------------------------------------
# ⚙️  CONFIGURATION DE ZSH COMME SHELL PAR DÉFAUT
# ------------------------------------------------------------------------------
print_section "Définir Zsh comme shell par défaut"
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
    echo -e "✅ ${YELLOW}Zsh est maintenant le shell par défaut${NC}"
else
    echo -e  "✅ ${YELLOW}Zsh est déjà le shell par défaut${NC}"
fi

# ------------------------------------------------------------------------------
# ⚙️  CONFIGURATION DE VIM
# ------------------------------------------------------------------------------
print_section "Configuration de vim"
cat << 'eof' > ~/.vimrc
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
eof

# ------------------------------------------------------------------------------
#  ⚙️  DÉACTIVER KVM POUR CETTE SESSION
# ------------------------------------------------------------------------------
print_section "Désactiver KVM pour cette session pour éviter les conflits de VMs imbriqués nested VMs..."

if sudo modprobe -r kvm_intel 2>/dev/null || sudo modprobe -r kvm_amd 2>/dev/null; then
    sudo modprobe -r kvm && echo -e "✅ ${YELLOW}KVM désactiver${NC}"
else
    echo -e "${YELLOW}Impossible de désactiver KVM${NC}"
fi

# ------------------------------------------------------------------------------
# ✅ FIN
# ------------------------------------------------------------------------------
echo -e "\n🎉 ${GREEN}Installation terminée !${NC}"
