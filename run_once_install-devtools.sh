#!/usr/bin/env bash
set -euo pipefail

is_wsl() {
    [[ -n "${WSL_DISTRO_NAME:-}" || -n "${WSL_INTEROP:-}" ]] || \
        grep -qi microsoft /proc/sys/kernel/osrelease 2>/dev/null
}

if is_wsl; then
    tooling="${DOTFILES_WSL_TOOLING:-}"
    if [[ -z "$tooling" && -t 0 && -t 1 ]]; then
        read -r -p "WSL setup: choose 'base' (default) or 'development': " tooling
    fi
    tooling="${tooling:-base}"

    case "$tooling" in
        development|dev)
            echo "WSL development tooling selected"
            ;;
        base)
            echo "WSL base CLI selected; skipping development tooling"
            exit 0
            ;;
        *)
            printf "Unknown WSL tooling choice: %s (use base or development)\\n" "$tooling" >&2
            exit 2
            ;;
    esac
fi

if command -v rpm-ostree >/dev/null; then
    echo "Atomic Fedora detected"

    # Container bestaat al, dus niet opnieuw maken
    toolbox create dev || true

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
