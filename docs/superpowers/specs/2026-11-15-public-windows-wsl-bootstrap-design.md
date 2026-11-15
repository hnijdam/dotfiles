# Public Windows and WSL Bootstrap Design

## Intent

Provide one reliable first-installation route for a public ChezMoi dotfiles repository on native Windows, Fedora WSL, Ubuntu/Debian WSL, and Linux desktops.

## Goals

- Install Git, ChezMoi, and GitHub CLI (`gh`) before applying dotfiles.
- Use PowerShell only on native Windows and Bash only on Linux/WSL.
- Detect WSL and WSLg without an external X server.
- Install VS Code and Emacs by default on native Windows and Linux desktops.
- Install VS Code and Emacs as Linux GUI applications in WSL only when WSLg is available.
- Keep Flatpak and Windows-only tools out of WSL.
- Keep existing public-repository bootstrap free of GitHub credentials; `gh auth login` remains available for later private Git operations.

## Non-goals

- No third-party X server installation.
- No automatic GitHub sign-in or token handling.
- No GUI editor installation when WSLg is unavailable.

## Architecture

Two public bootstrap entry points live in the repository: a PowerShell script for Windows and a Bash script for Linux/WSL. Each installs ChezMoi using the platform package manager, then invokes `chezmoi init --apply hnijdam` with an inaccessible `XDG_RUNTIME_DIR` removed.

The existing ChezMoi hooks remain responsible for dotfile application. The Linux hooks receive explicit WSLg-aware editor installation: WSLg enables the Microsoft VS Code repository plus the Linux `code` and `emacs` packages; non-WSLg WSL reports the skipped GUI editors without adding an X server.

## Verification

Shell tests mock `dnf`, `apt-get`, WSL variables, and WSLg variables to prove package selection. PowerShell static tests verify the Windows bootstrap installs Scoop, Git, ChezMoi, `gh`, VS Code, and Emacs. ChezMoi Windows rendering continues to exclude Bash hooks.
