param(
    [ValidateSet('Serve', 'Build')]
    [string]$Command = 'Serve',

    [string]$BindAddress = '127.0.0.1',

    [ValidateRange(1, 65535)]
    [int]$Port = 8000,

    [switch]$SkipInstall
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$venvPath = Join-Path $repoRoot '.venv-docs'
$pythonPath = Join-Path $venvPath 'Scripts\python.exe'
$requirementsPath = Join-Path $repoRoot 'requirements-docs.txt'
$mkdocsConfigPath = Join-Path $repoRoot 'mkdocs.yml'

if (-not (Get-Command python.exe -ErrorAction SilentlyContinue)) {
    throw 'Python 3 is required for documentation builds. Install Python 3.12 or newer and run this script again.'
}

if (-not (Test-Path -LiteralPath $pythonPath -PathType Leaf)) {
    Write-Host 'Creating documentation virtual environment...'
    python -m venv $venvPath
}

if (-not $SkipInstall) {
    Write-Host 'Installing pinned documentation dependencies...'
    & $pythonPath -m pip install --disable-pip-version-check -r $requirementsPath
}

Push-Location $repoRoot

try {
    if ($Command -eq 'Serve') {
        $address = "${BindAddress}:$Port"
        Write-Host "Serving documentation on http://$address/"
        & $pythonPath -m mkdocs serve --config-file $mkdocsConfigPath --dev-addr $address --strict
    }
    else {
        Write-Host 'Building documentation in strict mode...'
        & $pythonPath -m mkdocs build --config-file $mkdocsConfigPath --strict
    }

    if ($LASTEXITCODE -ne 0) {
        throw "MkDocs $Command failed with exit code $LASTEXITCODE."
    }
}
finally {
    Pop-Location
}
