#Requires -Version 5.1
<#
    windows.ps1 - deploy Windows-relevant dotfiles.

    Deploys tracked configs by creating a symbolic link (falls back to a
    hard link, then to a copy). Existing real files are moved to
    "<path>.backup" (or "<path>.backup.<timestamp>" if a backup already
    exists) instead of being deleted.

    Symbolic links need Developer Mode or an elevated shell. A copy
    fallback will not stay in sync with this repo.

    Usage:
        powershell -ExecutionPolicy Bypass -File .\windows.ps1
        powershell -ExecutionPolicy Bypass -File .\windows.ps1 -DryRun
#>

[CmdletBinding()]
param(
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

$Dotfiles = $PSScriptRoot

function Invoke-DotStep {
    param([scriptblock]$Action, [string]$Description)

    if ($DryRun) {
        Write-Host "dry-run: $Description"
        return $false
    }

    & $Action
    return $true
}

function New-DotLink {
    param(
        [Parameter(Mandatory)][string]$Source,
        [Parameter(Mandatory)][string]$Destination
    )

    if (-not (Test-Path -LiteralPath $Source)) {
        Write-Warning "skip (source missing): $Source"
        return
    }

    $destDir = Split-Path -Parent $Destination
    if ($destDir -and -not (Test-Path -LiteralPath $destDir)) {
        $null = Invoke-DotStep -Description "mkdir $destDir" -Action {
            New-Item -ItemType Directory -Force -Path $destDir | Out-Null
        }
    }

    if (Test-Path -LiteralPath $Destination) {
        $item = Get-Item -LiteralPath $Destination -Force
        $alreadyLinked = $item.LinkType -and (
            $item.Target -eq $Source -or
            ($item.Target -is [array] -and $item.Target -contains $Source)
        )
        if ($alreadyLinked) {
            Write-Host "skip (already linked): $Destination"
            return
        }

        if ($item.LinkType) {
            $null = Invoke-DotStep -Description "rm $Destination" -Action {
                Remove-Item -LiteralPath $Destination -Force
            }
        }
        else {
            $backup = "$Destination.backup"
            if (Test-Path -LiteralPath $backup) {
                $stamp = Get-Date -Format 'yyyyMMddHHmmss'
                $backup = "$Destination.backup.$stamp"
            }
            $null = Invoke-DotStep -Description "mv $Destination -> $backup" -Action {
                Move-Item -LiteralPath $Destination -Destination $backup -Force
            }
            Write-Host "backup: $Destination -> $backup"
        }
    }

    if ($DryRun) {
        Write-Host "dry-run: link $Destination -> $Source"
        return
    }

    try {
        New-Item -ItemType SymbolicLink -Path $Destination -Target $Source | Out-Null
        Write-Host "link:   $Destination -> $Source"
    }
    catch {
        try {
            New-Item -ItemType HardLink -Path $Destination -Target $Source | Out-Null
            Write-Warning "hard:   $Destination -> $Source (symlink failed; enable Developer Mode for real links)"
        }
        catch {
            Copy-Item -LiteralPath $Source -Destination $Destination -Force
            Write-Warning "copy:   $Destination <- $Source (not linked; later repo edits will not sync)"
        }
    }
}

function Get-WindowsTerminalSettingsPath {
    $packages = Join-Path $env:LOCALAPPDATA 'Packages'
    $candidates = Get-ChildItem -Path $packages -Directory -ErrorAction SilentlyContinue |
        Where-Object {
            $_.Name -like 'Microsoft.WindowsTerminal_*' -or
            $_.Name -like 'Microsoft.WindowsTerminalPreview_*'
        } |
        ForEach-Object { Join-Path $_.FullName 'LocalState\settings.json' } |
        Where-Object { Test-Path -LiteralPath $_ }

    $preview = $candidates | Where-Object { $_ -like '*WindowsTerminalPreview*' }
    $stable = $candidates | Where-Object { $_ -notlike '*WindowsTerminalPreview*' }

    if ($stable) { return @($stable)[0] }
    if ($preview) { return @($preview)[0] }
    return $null
}

$HomeDir = $env:USERPROFILE

# --- mappings -------------------------------------------------------------
$links = @(
    @{ Source = Join-Path $Dotfiles '.gitconfig'; Destination = Join-Path $HomeDir '.gitconfig' }
    @{ Source = Join-Path $Dotfiles '.npmrc';     Destination = Join-Path $HomeDir '.npmrc' }
    @{ Source = Join-Path $Dotfiles 'cargo.toml'; Destination = Join-Path $HomeDir '.cargo\config.toml' }
)

$wtSettings = Get-WindowsTerminalSettingsPath
if ($wtSettings) {
    $links += @{ Source = Join-Path $Dotfiles 'windows terminal'; Destination = $wtSettings }
}
else {
    Write-Warning 'skip (Windows Terminal not found)'
}

foreach ($l in $links) {
    New-DotLink -Source $l.Source -Destination $l.Destination
}

Write-Host ''
Write-Host 'Done.'
Write-Host 'Note: scoop.json is not deployed by this script. Import it with scoop import .\scoop.json if needed.'

