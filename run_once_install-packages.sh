#!/usr/bin/env bash
set -euo pipefail

is_wsl() {
    [[ -n "${WSL_DISTRO_NAME:-}" || -n "${WSL_INTEROP:-}" ]] || \
        grep -qi microsoft /proc/sys/kernel/osrelease 2>/dev/null
}

is_wslg() {
    [[ -d /mnt/wslg || -n "${WAYLAND_DISPLAY:-}" ]]
}

if is_wsl; then
    echo "WSL detected; installing Linux command-line tools only"
    if command -v apt-get >/dev/null; then
        wsl_package_manager=apt
        sudo apt-get update
        sudo apt-get install -y \
            git curl wget zsh tmux neovim ripgrep fd-find fzf bat htop btop \
            tree unzip tar python3 python3-pip nodejs npm
    elif command -v dnf >/dev/null; then
        wsl_package_manager=dnf
        sudo dnf install -y \
            git curl wget zsh tmux neovim ripgrep fd fzf bat htop btop \
            tree unzip tar python3 python3-pip nodejs npm
    else
        wsl_package_manager=none
        echo "No supported WSL package manager found; skipping package installation"
    fi
    if is_wslg; then
        echo "WSLg detected; installing Emacs and VS Code for Linux"
        if [[ "$wsl_package_manager" == dnf ]]; then
            sudo dnf install -y emacs code || echo "Install VS Code from the Microsoft repository if it is unavailable."
        elif [[ "$wsl_package_manager" == apt ]]; then
            sudo apt-get install -y emacs code || echo "Install VS Code from the Microsoft repository if it is unavailable."
        fi
    else
        echo "WSL detected without WSLg; skipping GUI editors"
    fi
    exit 0
fi

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
