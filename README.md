## Installeren

Installeer eerst Git en curl:

```sh
# Fedora Desktop
sudo dnf install -y git curl

# Ubuntu of Debian, waaronder WSL
sudo apt-get update && sudo apt-get install -y git curl
```

Haal daarna de dotfiles op en pas ze toe:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply hnijdam
```

De installatie installeert ZSH, Oh My Zsh en Starship waar mogelijk. Op een
normale Linux-desktop worden ook Flatpak-apps zoals Blackbox geïnstalleerd;
op WSL worden deze overgeslagen. Windows Terminal blijft daar je terminal.

Stel ZSH optioneel in als je login-shell en start daarna een nieuwe terminal:

```sh
chsh -s "$(command -v zsh)"
```

Op een extra machine voer je `chezmoi init --apply hnijdam` uit; voor latere
wijzigingen gebruik je `chezmoi update`.
