#!/usr/bin/env bash

cd "$(chezmoi source-path)"

if ! git diff --quiet || ! git diff --cached --quiet; then
    git add .
    git commit -m "dotfiles update $(date '+%Y-%m-%d %H:%M')"
    git push
fi