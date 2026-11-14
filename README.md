## Installeren

### Fedora, Debian/Ubuntu en WSL

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

### Windows 10/11

Open PowerShell en bootstrap Scoop voor je huidige gebruiker. Dit vereist geen
adminrechten:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
scoop install git chezmoi
```

Open daarna een nieuwe PowerShell-sessie en haal de dotfiles op:

```powershell
chezmoi init --apply hnijdam
```

Het PowerShell-script installeert Scoop in je gebruikersprofiel. Standaard
installeert het PowerShell 7, Git, VS Code, Python, Node.js LTS en Starship.
Extra CLI-tools en de C++-toolchain zijn optioneel:

```powershell
pwsh -NoProfile -File .\run_once_install-devtools-windows.ps1 -IncludeOptionalCli
```

```powershell
pwsh -NoProfile -File .\run_once_install-devtools-windows.ps1 -IncludeCppToolchain
```

Voor de fzf-keybindings in PowerShell:

```powershell
Install-Module PSFzf -Scope CurrentUser
```

De optionele CLI-tools zijn eza, bat, fzf, zoxide, ripgrep, fd en GitHub CLI;
de C++-toolchain bestaat uit CMake en LLVM. Windows Terminal kun je via de
Microsoft Store installeren; het beheerde profiel is voor PowerShell 7.
