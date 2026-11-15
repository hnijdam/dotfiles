#!/usr/bin/env bash
set -euo pipefail

if [[ -n "${WSL_DISTRO_NAME:-}" || -n "${WSL_INTEROP:-}" ]] || \
    grep -qi microsoft /proc/sys/kernel/osrelease 2>/dev/null; then
	echo "WSL detected; skipping desktop Flatpak apps"
	exit 0
fi

if ! command -v flatpak >/dev/null 2>&1; then
	echo "Flatpak is not installed; skipping Flatpak apps"
	exit 0
fi

flatpak update -y

flatpak_apps=(
	com.visualstudio.code
	org.mozilla.firefox
	com.spotify.Client
	com.slack.Slack
	com.raggesilver.BlackBox
)

flatpak install -y flathub "${flatpak_apps[@]}"
