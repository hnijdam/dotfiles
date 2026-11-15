#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "$0")/.." && pwd)

assert_contains() {
    local file=$1 expected=$2
    grep -Fq -- "$expected" "$file" || {
        printf 'Expected %s to contain: %s\n' "$file" "$expected" >&2
        exit 1
    }
}

assert_contains "$repo_root/run_once_install-packages.sh" 'is_wsl()'
assert_contains "$repo_root/run_once_install-packages.sh" 'WSL_DISTRO_NAME'
assert_contains "$repo_root/run_once_install-packages.sh" 'WSL_INTEROP'
assert_contains "$repo_root/run_once_install-devtools.sh" 'DOTFILES_WSL_TOOLING'
assert_contains "$repo_root/run_once_install-devtools.sh" 'base'
assert_contains "$repo_root/.chezmoiignore" 'scripts/windows/**'
assert_contains "$repo_root/.chezmoiignore" 'scripts/linux/**'
assert_contains "$repo_root/.chezmoiignore" 'scripts/darwin/**'
assert_contains "$repo_root/scripts/windows/run_once_install-devtools-windows.ps1" 'native PowerShell'
assert_contains "$repo_root/README.md" '### Native Windows (PowerShell)'
assert_contains "$repo_root/README.md" '### WSL (Ubuntu/Debian)'
assert_contains "$repo_root/README.md" 'DOTFILES_WSL_TOOLING=development'

mock_bin=$(mktemp -d)
mock_log=$(mktemp)
trap 'rm -rf "$mock_bin" "$mock_log"' EXIT
printf '#!/bin/sh\nexec "$@"\n' > "$mock_bin/sudo"
printf '#!/bin/sh\nprintf "%%s\\n" "$*" >> "$MOCK_LOG"\n' > "$mock_bin/apt-get"
printf '#!/bin/sh\nprintf "%%s\\n" "$*" >> "$MOCK_LOG"\n' > "$mock_bin/rpm-ostree"
chmod +x "$mock_bin/sudo" "$mock_bin/apt-get" "$mock_bin/rpm-ostree"

PATH="$mock_bin:$PATH" MOCK_LOG="$mock_log" WSL_DISTRO_NAME=Ubuntu bash "$repo_root/run_once_install-packages.sh"
grep -Fq 'install -y' "$mock_log" || {
    printf 'WSL must prefer the CLI-only apt route.\n' >&2
    exit 1
}
if grep -Eq 'flatpak|vlc|gimp|inkscape' "$mock_log"; then
    printf 'WSL must not install desktop packages.\n' >&2
    exit 1
fi

printf 'Installer routing checks passed.\n'
