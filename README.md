# MochaPosh

> A minimal, beautiful PowerShell setup — Catppuccin Mocha themed, one-command install.

![PowerShell](https://img.shields.io/badge/PowerShell-7%2B-blue?logo=powershell)
![Windows](https://img.shields.io/badge/Windows-10%2F11-0078D4?logo=windows)
![Theme](https://img.shields.io/badge/theme-Catppuccin%20Mocha-cba4f7)

---

## What's included

| Tool | Purpose |
|---|---|
| [Oh My Posh](https://ohmyposh.dev) | Two-line minimal prompt with git status |
| [CaskaydiaCove NF](https://www.nerdfonts.com) | Nerd Font — renders icons in the prompt and file listing |
| [Terminal-Icons](https://github.com/devblackops/Terminal-Icons) | File/folder icons in `ls` output |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smart `cd` — jump to any dir by partial name |
| [fzf](https://github.com/junegunn/fzf) + [PSFzf](https://github.com/kelleyma49/PSFzf) | Fuzzy history picker (`Ctrl+R`) and file picker (`Ctrl+T`) |
| [bat](https://github.com/sharkdp/bat) | Syntax-highlighted `cat` with line numbers |
| [delta](https://github.com/dandavison/delta) | Beautiful side-by-side git diffs |

All tools are themed with **Catppuccin Mocha** for a cohesive look.

---

## Quick install

> Requires PowerShell 7+ and [winget](https://aka.ms/winget).

```powershell
irm https://raw.githubusercontent.com/imjohnmarkk/mochaposh/main/install.ps1 | iex
```

That's it. The script installs all tools, copies the profile and theme, and configures git.

---

## Manual install

<details>
<summary>Step-by-step instructions</summary>

**1. Install CLI tools**
```powershell
winget install JanDeDobbeleer.OhMyPosh junegunn.fzf ajeetdsouza.zoxide sharkdp.bat dandavison.delta
```

**2. Install Nerd Font**
```powershell
oh-my-posh font install CascadiaCode
```

**3. Install PowerShell modules**
```powershell
Install-Module Terminal-Icons, PSFzf -Scope CurrentUser -Force
```

**4. Copy the theme**
```powershell
New-Item -ItemType Directory -Force "$env:USERPROFILE\.config\ohmyposh"
Copy-Item themes\minimal.json "$env:USERPROFILE\.config\ohmyposh\minimal.json"
```

**5. Copy the profile**
```powershell
Copy-Item profile.ps1 $PROFILE
```

**6. Install bat theme**
```powershell
New-Item -ItemType Directory -Force "$env:APPDATA\bat\themes"
Invoke-WebRequest "https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme" `
    -OutFile "$env:APPDATA\bat\themes\Catppuccin Mocha.tmTheme"
bat cache --build
```

**7. Configure git delta**

Append the contents of `gitconfig-delta` to your `~/.gitconfig`.

</details>

---

## Windows Terminal setup

After install, configure Windows Terminal manually:

1. Open **Settings** (`Ctrl+,`)
2. Go to **Profiles → PowerShell → Appearance**
3. Set **Font face** to `CaskaydiaCove NF`
4. Set **Color scheme** to `Catppuccin Mocha`

To add the color scheme, open `settings.json` (`Ctrl+Shift+,`) and merge the contents of `windows-terminal/settings.json` into the `"schemes"` array.

---

## Keybindings

| Key | Action |
|---|---|
| `Ctrl+R` | Fuzzy search command history |
| `Ctrl+T` | Fuzzy file picker (inserts path at cursor) |
| `↑` / `↓` | Search history filtered by current input |
| `Tab` | Menu-style tab completion |
| `z <partial>` | Jump to frecent directory |
| `ls` / `ll` | List with icons, folders first |
| `cat <file>` | Syntax-highlighted file view |
| `g` | Alias for `git` |

---

## Prompt reference

```
 ~/projects/my-app   main ✓       ← blue path + green git (clean)
 ~/projects/my-app   main ✎       ← orange (unstaged changes)
 ~/projects/my-app   main +       ← yellow (staged changes)
❯                                  ← cursor line
```

---

## Customization

**Swap the Oh My Posh theme**

Edit `~/.config/ohmyposh/minimal.json` or point to a different theme:
```powershell
# In profile.ps1, change the --config path:
oh-my-posh init pwsh --config "$(oh-my-posh get shell)" | Invoke-Expression
# Or browse built-in themes:
Get-PoshThemes
```

**Change the font**

Any [Nerd Font](https://www.nerdfonts.com/font-downloads) works. Install via:
```powershell
oh-my-posh font install <FontName>
```
Then update the font in Windows Terminal settings.

**Add more aliases**

Append to `profile.ps1` — changes take effect after `. $PROFILE`.

---

## License

MIT
