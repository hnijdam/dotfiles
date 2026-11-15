$ErrorActionPreference = 'Stop'

if ($env:OS -ne 'Windows_NT') {
    throw 'Run this bootstrap from native Windows PowerShell, not WSL.'
}

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Invoke-RestMethod -Uri 'https://get.scoop.sh' | Invoke-Expression
}

$env:PATH = "$HOME\scoop\shims;$env:PATH"
scoop install git chezmoi gh vscode emacs
chezmoi init --apply hnijdam
