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

else
    echo "Classic Fedora detected"

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
fi
