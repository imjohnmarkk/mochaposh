#Requires -Version 7.0
<#
.SYNOPSIS
    MochaPosh — one-command PowerShell setup installer.
.DESCRIPTION
    Installs and configures a beautiful, minimal PowerShell environment:
    Oh My Posh, Terminal-Icons, zoxide, fzf, bat, delta, PSFzf.
    All themed with Catppuccin Mocha.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Step  { param($msg) Write-Host "  $msg" -ForegroundColor Cyan }
function Write-Ok    { param($msg) Write-Host "  ✓ $msg" -ForegroundColor Green }
function Write-Warn  { param($msg) Write-Host "  ! $msg" -ForegroundColor Yellow }

Write-Host ""
Write-Host "  MochaPosh installer" -ForegroundColor Magenta
Write-Host "  ───────────────────────────────────" -ForegroundColor DarkGray
Write-Host ""

# ── 1. Check PowerShell version ───────────────────────────────────────────────
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Error "PowerShell 7+ is required. Download it from https://aka.ms/powershell"
    exit 1
}
Write-Ok "PowerShell $($PSVersionTable.PSVersion)"

# ── 2. Install CLI tools via winget ──────────────────────────────────────────
Write-Step "Installing CLI tools (oh-my-posh, fzf, zoxide, bat, delta)..."
$tools = @(
    'JanDeDobbeleer.OhMyPosh',
    'junegunn.fzf',
    'ajeetdsouza.zoxide',
    'sharkdp.bat',
    'dandavison.delta'
)
foreach ($id in $tools) {
    winget install $id --accept-package-agreements --accept-source-agreements --silent 2>$null
}
# Refresh PATH so newly installed tools are available
$env:PATH = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';' +
            [System.Environment]::GetEnvironmentVariable('PATH', 'User')
Write-Ok "CLI tools installed"

# ── 3. Install Nerd Font ──────────────────────────────────────────────────────
Write-Step "Installing CaskaydiaCove Nerd Font..."
oh-my-posh font install CascadiaCode 2>$null
Write-Ok "Font installed"

# ── 4. Install PowerShell modules ─────────────────────────────────────────────
Write-Step "Installing PowerShell modules (Terminal-Icons, PSFzf)..."
Install-Module Terminal-Icons -Repository PSGallery -Force -Scope CurrentUser
Install-Module PSFzf          -Repository PSGallery -Force -Scope CurrentUser
Write-Ok "Modules installed"

# ── 5. Copy Oh My Posh theme ──────────────────────────────────────────────────
Write-Step "Copying Oh My Posh theme..."
$themeDir = "$env:USERPROFILE\.config\ohmyposh"
New-Item -ItemType Directory -Force $themeDir | Out-Null
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Copy-Item "$scriptDir\themes\minimal.json" "$themeDir\minimal.json" -Force
Write-Ok "Theme copied to $themeDir\minimal.json"

# ── 6. Install PowerShell profile ────────────────────────────────────────────
Write-Step "Installing PowerShell profile..."
$profileDir = Split-Path $PROFILE
New-Item -ItemType Directory -Force $profileDir | Out-Null
if (Test-Path $PROFILE) {
    $backup = "$PROFILE.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Copy-Item $PROFILE $backup
    Write-Warn "Existing profile backed up to $backup"
}
Copy-Item "$scriptDir\profile.ps1" $PROFILE -Force
Write-Ok "Profile installed at $PROFILE"

# ── 7. Install bat Catppuccin Mocha theme ────────────────────────────────────
Write-Step "Installing bat Catppuccin Mocha theme..."
$batThemeDir = "$env:APPDATA\bat\themes"
New-Item -ItemType Directory -Force $batThemeDir | Out-Null
$batThemeUrl = "https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme"
Invoke-WebRequest -Uri $batThemeUrl -OutFile "$batThemeDir\Catppuccin Mocha.tmTheme" -UseBasicParsing
bat cache --build 2>$null
Write-Ok "bat theme installed"

# ── 8. Configure git delta ────────────────────────────────────────────────────
Write-Step "Configuring git delta..."
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
git config --global delta.side-by-side true
git config --global delta.line-numbers true
git config --global delta.syntax-theme 'Catppuccin Mocha'
git config --global merge.conflictstyle zdiff3
Write-Ok "git delta configured"

# ── Done ──────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ✓ MochaPosh installed!" -ForegroundColor Green
Write-Host ""
Write-Host "  Next steps:" -ForegroundColor White
Write-Host "  1. Restart Windows Terminal" -ForegroundColor DarkGray
Write-Host "  2. In WT Settings → PowerShell → Appearance:" -ForegroundColor DarkGray
Write-Host "     · Font: CaskaydiaCove NF" -ForegroundColor DarkGray
Write-Host "     · Color scheme: Catppuccin Mocha  (from windows-terminal/settings.json)" -ForegroundColor DarkGray
Write-Host "  3. Open a new PowerShell tab — enjoy!" -ForegroundColor DarkGray
Write-Host ""
