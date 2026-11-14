if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& zoxide init powershell)
}

if (Get-Module -ListAvailable -Name PSFzf) {
    Import-Module PSFzf
}

if (Get-Command eza -ErrorAction SilentlyContinue) {
    $env:EZA_COLORS = 'di=38;5;75:ln=38;5;81:ex=38;5;114:fi=38;5;252:*.tar=38;5;180:*.gz=38;5;180:*.zip=38;5;180:*.7z=38;5;180:*.rpm=38;5;180:*.deb=38;5;180:*.jpg=38;5;183:*.jpeg=38;5;183:*.png=38;5;183:*.gif=38;5;183:*.svg=38;5;183:*.mp3=38;5;116:*.wav=38;5;116:*.flac=38;5;116:*.mp4=38;5;116:*.mkv=38;5;116:*.webm=38;5;116:*.py=38;5;221:*.sh=38;5;114:*.json=38;5;180:*.yaml=38;5;180:*.yml=38;5;180:*.md=38;5;252'

    function ll { & eza --icons --group-directories-first -lah @args }
    function la { & eza --icons --group-directories-first -a @args }
    function lt { & eza --icons --group-directories-first --tree --level=2 @args }
}

if (Get-Command bat -ErrorAction SilentlyContinue) {
    Remove-Item Alias:cat -ErrorAction SilentlyContinue
    function cat { & bat @args }
}

function c { Clear-Host }
function home { Set-Location $HOME }
function projects { Set-Location (Join-Path $HOME 'Projects') }

function Invoke-Lookup {
    param([Parameter(Mandatory)][ValidateSet('main.py', 'script.py')][string]$ScriptName)

    $projectPath = Join-Path $HOME 'Development/DNS-CLI-tool'
    if (-not (Test-Path -LiteralPath $projectPath -PathType Container)) {
        throw "Lookup project not found: $projectPath"
    }

    Push-Location $projectPath
    try {
        foreach ($activationScript in @('.env/Scripts/Activate.ps1', '.venv/Scripts/Activate.ps1')) {
            $activationPath = Join-Path $projectPath $activationScript
            if (Test-Path -LiteralPath $activationPath -PathType Leaf) {
                . $activationPath
                break
            }
        }
        & python $ScriptName
    }
    finally {
        Pop-Location
    }
}

function lookup { Invoke-Lookup -ScriptName 'script.py' }
function lookup-main { Invoke-Lookup -ScriptName 'main.py' }
function lookup-script { Invoke-Lookup -ScriptName 'script.py' }

foreach ($toolPath in @((Join-Path $HOME 'jorrit-management'), (Join-Path $HOME '.lmstudio/bin'), (Join-Path $HOME '.local/bin'))) {
    if ((Test-Path -LiteralPath $toolPath -PathType Container) -and $env:PATH -notlike "*$toolPath*") {
        $env:PATH = "$toolPath;$env:PATH"
    }
}

if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    if ((Get-Module PSReadLine).Version -ge [version]'2.2.0') {
        Set-PSReadLineOption -PredictionSource History -PredictionViewStyle ListView
    }
}

if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (& starship init powershell)
}