# ── Prompt ──────────────────────────────────────────────────────────────────
$_ompCache = "$env:TEMP\mochaposh-omp.ps1"
if (-not (Test-Path $_ompCache) -or ((Get-Date) - (Get-Item $_ompCache).LastWriteTime).TotalHours -gt 24) {
    oh-my-posh init pwsh --config "$env:USERPROFILE\.config\ohmyposh\minimal.json" | Out-File $_ompCache -Encoding utf8
}
. $_ompCache

# ── Icons ────────────────────────────────────────────────────────────────────
Import-Module Terminal-Icons

# ── PSReadLine (better history & keybindings) ────────────────────────────────
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Key UpArrow   -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab       -Function MenuComplete

# ── zoxide (smart cd) ────────────────────────────────────────────────────────
$_zoxideCache = "$env:TEMP\mochaposh-zoxide.ps1"
if (-not (Test-Path $_zoxideCache)) {
    zoxide init powershell | Out-File $_zoxideCache -Encoding utf8
}
. $_zoxideCache

# ── fzf + PSFzf ──────────────────────────────────────────────────────────────
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t'
Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'

$env:FZF_DEFAULT_OPTS = @"
--height 40% --layout=reverse --border=rounded
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
--color=fg:#cdd6f4,header:#f38ba8,info:#cba4f7,pointer:#f5e0dc
--color=marker:#b5e8e0,fg+:#cdd6f4,prompt:#cba4f7,hl+:#f38ba8
"@

# ── bat (better cat) ─────────────────────────────────────────────────────────
$env:BAT_THEME = "Catppuccin Mocha"
function cat { bat --style=numbers,changes,header @args }

# ── ls: icon-aware directory listing ─────────────────────────────────────────
function ll {
    param([string]$Path = '.')
    Get-ChildItem -Force $Path | Sort-Object { $_.PSIsContainer } -Descending | Format-TerminalIcons
}
function ls { ll @args }

# ── Useful aliases ────────────────────────────────────────────────────────────
Set-Alias -Name g -Value git
