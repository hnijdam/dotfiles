#!/usr/bin/env bash

sudo dnf update -y

sudo dnf install -y \
    git \
    curl \
    wget \
    zsh \
    neovim \
    tmux \
    ripgrep \
    fd \
    fzf \
    bat \
    htop