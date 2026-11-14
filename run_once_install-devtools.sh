#!/usr/bin/env bash
set -e

if command -v rpm-ostree >/dev/null; then
    echo "Atomic Fedora detected"

    # Container bestaat al, dus niet opnieuw maken
    toolbox create dev || true

    # Gebruik DNF5 syntax: 'group install', NIET 'groupinstall'
    toolbox run --container dev dnf group install -y "Development Tools"

    toolbox run --container dev dnf install -y \
        python3 \
        python3-pip \
        nodejs \
        npm \
        gcc \
        gcc-c++ \
        make \
        cmake \
        gdb \
        clang \
        clang-tools-extra \
        cppcheck \
        clang-format \
        clang-tidy \
        gyp \
        gyp-next

elif command -v dnf >/dev/null; then
    echo "Fedora detected"

    sudo dnf group install -y "Development Tools"
    sudo dnf install -y \
        python3 \
        python3-pip \
        nodejs \
        npm \
        gcc \
        gcc-c++ \
        make \
        cmake \
        gdb \
        clang \
        clang-tools-extra
elif command -v apt-get >/dev/null; then
    echo "Debian-based Linux detected"
    sudo apt-get update
    sudo apt-get install -y \
        build-essential \
        python3 \
        python3-pip \
        nodejs \
        npm \
        cmake \
        gdb \
        clang \
        clang-tools-extra
else
    echo "No supported package manager found; skipping development tools"
fi
