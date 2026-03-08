#!/usr/bin/env bash
set -e

if command -v rpm-ostree >/dev/null; then
    echo "Atomic Fedora detected"

    toolbox create dev || true

    toolbox run --container dev sudo dnf groupinstall -y "Development Tools"

    toolbox run --container dev sudo dnf install -y \
        python3 \
        python3-pip \
        nodejs \
        npm \
        gcc \
        gcc-c++ \
        make \
        cmake \
        gdb \
        valgrind \
        strace \
        ltrace \
        perf \
        gprof \
        lldb \
        clang \
        clang-tools-extra \
        cppcheck \
        clang-format \
        clang-tidy \
        gyp \
        gyp-next

else
    echo "Classic Fedora detected"

    sudo dnf groupinstall -y "Development Tools"

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
        valgrind \
        strace \
        ltrace \
        perf \
        gprof \
        lldb \
        clang \
        clang-tools-extra \
        cppcheck \
        clang-format \
        clang-tidy \
        gyp \
        gyp-next
fi
