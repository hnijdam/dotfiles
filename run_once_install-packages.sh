#!/usr/bin/env bash
set -e

if command -v rpm-ostree >/dev/null; then
    echo "Atomic Fedora detected"

    sudo rpm-ostree install \
        git \
        curl \
        wget \
        zsh \
        tmux \
        neovim \
        ripgrep \
        fd-find \
        fzf \
        bat \
        htop \
        btop \
        tree \
        unzip \
        tar \
        python3 \
        python3-pip \
        nodejs \
        npm

    echo "Installing Flatpak apps"

    flatpak install -y flathub \
        com.visualstudio.code \
        org.videolan.VLC \
        org.gimp.GIMP \
        org.inkscape.Inkscape

else
    echo "Classic Fedora detected"

    sudo dnf update -y

    sudo dnf install -y \
        git \
        curl \
        wget \
        zsh \
        tmux \
        neovim \
        ripgrep \
        fd \
        fzf \
        bat \
        htop \
        btop \
        tree \
        unzip \
        tar \
        python3 \
        python3-pip \
        nodejs \
        npm \
        docker \
        docker-compose \
        code \
        vlc \
        gimp \
        inkscape \
        fira-code-fonts \
        google-noto-fonts \
        liberation-fonts \
        dejavu-sans-fonts
fi
