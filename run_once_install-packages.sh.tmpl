#!/usr/bin/env bash
set -e

if command -v rpm-ostree >/dev/null; then
    echo "Atomic Fedora detected"

    sudo rpm-ostree upgrade
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

    if command -v flatpak >/dev/null; then
        flatpak install -y flathub \
            com.visualstudio.code \
            org.videolan.VLC \
            org.gimp.GIMP \
            org.inkscape.Inkscape
    fi
elif command -v dnf >/dev/null; then
    echo "Fedora detected"
    sudo dnf upgrade -y

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
        vlc \
        gimp \
        inkscape \
        fira-code-fonts \
        liberation-fonts \
        dejavu-sans-fonts
elif command -v apt-get >/dev/null; then
    echo "Debian-based Linux detected"
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install -y \
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
else
    echo "No supported package manager found; skipping package installation"
fi
