# Dotfiles

Personal configs plus small deploy scripts. Clone this repo anywhere; the
scripts resolve paths from their own location.

## Install

Linux:

```bash
chmod +x linux.sh
./linux.sh
./linux.sh --dry-run   # preview only
```

Windows (PowerShell 5.1+). Symbolic links need Developer Mode or an
elevated shell; otherwise the script falls back to a hard link, then a
copy (copies will not stay in sync with this repo):

```powershell
powershell -ExecutionPolicy Bypass -File .\windows.ps1
powershell -ExecutionPolicy Bypass -File .\windows.ps1 -DryRun
```

Existing real files are moved to `<path>.backup`. If that backup already
exists, a timestamped file is used instead.

## Mappings

Shared (both scripts):

| Repo file    | Destination                |
| ------------ | -------------------------- |
| `.gitconfig` | `$HOME/.gitconfig`         |
| `.npmrc`     | `$HOME/.npmrc`             |
| `cargo.toml` | `$HOME/.cargo/config.toml` |

Linux only ([linux.sh](linux.sh)):

| Repo file     | Destination                      |
| ------------- | -------------------------------- |
| `config.fish` | `$HOME/.config/fish/config.fish` |

Windows only ([windows.ps1](windows.ps1)):

| Repo file          | Destination                                                                    |
| ------------------ | ------------------------------------------------------------------------------ |
| `windows terminal` | `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json` |

Stable Windows Terminal is preferred over Preview when both exist.

## Not deployed

`scoop.json` is a Scoop export, not a live config. Import it yourself:

```powershell
scoop import .\scoop.json
```
