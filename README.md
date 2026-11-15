## Installeren

### Linux (Fedora, Debian en Ubuntu)

Installeer eerst Git en curl:

```sh
# Fedora Desktop
sudo dnf install -y git curl

# Ubuntu of Debian
sudo apt-get update && sudo apt-get install -y git curl
```

Haal daarna de dotfiles op en pas ze toe:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin" init --apply hnijdam
```

De installatie installeert ZSH, Oh My Zsh en Starship waar mogelijk. Op een
normale Linux-desktop worden ook Flatpak-apps zoals Blackbox geïnstalleerd.

Stel ZSH optioneel in als je login-shell en start daarna een nieuwe terminal:

```sh
chsh -s "$(command -v zsh)"
```

Op een extra machine voer je `chezmoi init --apply hnijdam` uit; voor latere
wijzigingen gebruik je `chezmoi update`.

### WSL (Ubuntu/Debian)

Open je Linux-distributie in Windows Terminal, **niet** PowerShell. Gebruik
alleen de Linux-opdracht; voer geen `.ps1`-bestand uit vanuit WSL:

```sh
sudo apt-get update && sudo apt-get install -y git curl
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply hnijdam
```

De installatie herkent WSL automatisch. Kies `base` voor alleen CLI-tools of
`development` voor aanvullende bouw- en ontwikkeltools. In een niet-interactieve
sessie wordt veilig `base` gekozen. Wil je later ontwikkeltools toevoegen:

```sh
DOTFILES_WSL_TOOLING=development bash "$("$HOME/.local/bin/chezmoi" source-path)/run_once_install-devtools.sh"
```

Flatpak-apps, Scoop en Windows-desktoptools worden in WSL nooit gestart.

Voor Fedora, Ubuntu en Debian in WSL is de aanbevolen publieke bootstrap:

```sh
curl -fsLS https://raw.githubusercontent.com/hnijdam/dotfiles/main/bootstrap/bootstrap-linux.sh | bash
```

Hij installeert Git, ChezMoi, GitHub CLI en Emacs. Met WSLg worden ook de Linux-GUI-editors ingericht; er is geen aparte X-server nodig.

### Native Windows (PowerShell)

Open **PowerShell** (niet WSL) en bootstrap Scoop voor je huidige gebruiker.
Dit vereist geen adminrechten. Voer vanuit PowerShell geen `.sh`-scripts uit:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
scoop install git chezmoi
```

Of gebruik de volledige publieke bootstrap (Git, ChezMoi, GitHub CLI, VS Code en Emacs):

```powershell
irm https://raw.githubusercontent.com/hnijdam/dotfiles/main/bootstrap/bootstrap-windows.ps1 | iex
```

Open daarna een nieuwe PowerShell-sessie en haal de dotfiles op:

```powershell
chezmoi init --apply hnijdam
```

Het PowerShell-script installeert Scoop in je gebruikersprofiel. Standaard
installeert het PowerShell 7, Git, VS Code, Python, Node.js LTS en Starship.
Extra CLI-tools en de C++-toolchain zijn optioneel:

```powershell
pwsh -NoProfile -File (Join-Path (chezmoi source-path) 'scripts/windows/run_once_install-devtools-windows.ps1') -IncludeOptionalCli
```

```powershell
pwsh -NoProfile -File (Join-Path (chezmoi source-path) 'scripts/windows/run_once_install-devtools-windows.ps1') -IncludeCppToolchain
```

Voor de fzf-keybindings in PowerShell:

```powershell
Install-Module PSFzf -Scope CurrentUser
```

De optionele CLI-tools zijn eza, bat, fzf, zoxide, ripgrep, fd en GitHub CLI;
de C++-toolchain bestaat uit CMake en LLVM. Windows Terminal kun je via de
Microsoft Store installeren; het beheerde profiel is voor PowerShell 7.

## macOS

Chezmoi gebruikt intern de naam `darwin` voor macOS. De bestaande macOS-route
blijft ongewijzigd en valt buiten de Windows- en WSL-bootstrap.
