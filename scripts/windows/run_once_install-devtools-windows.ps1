param(
    [switch]$IncludeOptionalCli,
    [switch]$IncludeCppToolchain
)

$ErrorActionPreference = 'Stop'

if ($env:OS -ne 'Windows_NT') {
    throw 'This installer must run from native PowerShell on Windows. In WSL, use the Linux bootstrap from the README; do not run this .ps1 file there.'
}

if ($env:SCOOP_GLOBAL) {
    throw 'SCOOP_GLOBAL is set. Unset it so tools are installed only for the current user.'
}

$homeRoot = [System.IO.Path]::GetFullPath($HOME)
$homePrefix = $homeRoot
if (-not $homePrefix.EndsWith([string][System.IO.Path]::DirectorySeparatorChar)) {
    $homePrefix += [System.IO.Path]::DirectorySeparatorChar
}

$scoopRoot = if ($env:SCOOP) {
    [System.IO.Path]::GetFullPath($env:SCOOP)
} else {
    [System.IO.Path]::GetFullPath((Join-Path $homeRoot 'scoop'))
}

if (-not $scoopRoot.Equals($homeRoot, [System.StringComparison]::OrdinalIgnoreCase) -and
    -not $scoopRoot.StartsWith($homePrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Scoop must be installed under the current user's home directory: $scoopRoot"
}

$env:SCOOP = $scoopRoot

if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod -Uri 'https://get.scoop.sh' | Invoke-Expression
}

$scoopShims = Join-Path $env:SCOOP 'shims'
if (Test-Path -LiteralPath $scoopShims -PathType Container) {
    $env:PATH = "$scoopShims;$env:PATH"
}

$scoopCommand = Get-Command scoop -ErrorAction SilentlyContinue
if (-not $scoopCommand) {
    throw 'Scoop could not be installed for the current user.'
}

$packageNames = @('pwsh', 'git', 'vscode', 'python', 'nodejs-lts', 'starship')

if ($IncludeOptionalCli) {
    $packageNames += @('eza', 'bat', 'fzf', 'zoxide', 'ripgrep', 'fd', 'gh')
}

$bucketList = (& $scoopCommand.Source bucket list | Out-String)
if ($LASTEXITCODE -ne 0) {
    throw 'Could not list Scoop buckets.'
}
if ($bucketList -notmatch '(?m)^extras\s') {
    & $scoopCommand.Source bucket add extras
    if ($LASTEXITCODE -ne 0) {
        throw 'Could not add the Scoop extras bucket.'
    }
}

if ($IncludeCppToolchain) {
    $packageNames += @('cmake', 'llvm')
}

foreach ($packageName in $packageNames) {
    Write-Host "Installing or updating $packageName for the current user..."
    & $scoopCommand.Source install $packageName
    if ($LASTEXITCODE -ne 0) {
        throw "Scoop failed to install $packageName with exit code $LASTEXITCODE"
    }
}
