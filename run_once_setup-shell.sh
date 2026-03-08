#!/usr/bin/env bash

if ! command -v starship >/dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi