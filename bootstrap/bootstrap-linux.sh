#!/usr/bin/env bash
set -euo pipefail

is_wsl() {
  [[ -n "${WSL_DISTRO_NAME:-}" || -n "${WSL_INTEROP:-}" ]] || grep -qi microsoft /proc/sys/kernel/osrelease 2>/dev/null
}

if command -v dnf >/dev/null; then
  sudo dnf install -y git curl chezmoi gh emacs
elif command -v apt-get >/dev/null; then
  sudo apt-get update
  sudo apt-get install -y git curl chezmoi gh emacs
else
  echo 'Unsupported Linux package manager.' >&2
  exit 1
fi

if is_wsl; then
  if [[ -d /mnt/wslg || -n "${WAYLAND_DISPLAY:-}" ]]; then
    echo 'WSLg detected; GUI editors will be provisioned by the dotfiles hooks.'
  else
    echo 'WSL detected without WSLg; GUI editor provisioning will be skipped.'
  fi
fi

env -u XDG_RUNTIME_DIR chezmoi init --apply hnijdam
