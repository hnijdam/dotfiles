#!/usr/bin/env bash

if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  mkdir -p ~/.ssh
  chmod 700 ~/.ssh

  ssh-keygen -t ed25519 \
    -C "$(whoami)@$(hostname)" \
    -f ~/.ssh/id_ed25519 \
    -N ""
fi