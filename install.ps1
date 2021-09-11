#!/usr/bin/pwsh

function Main() {
    # write .gitconfig redirect
    $thisPath = $PSScriptRoot -replace "\\", "/"
    "[include]`n    path = $thisPath/.gitconfig" | Out-File -FilePath "~/.gitconfig"

    # Windows-specific
    if ($IsWindows) {
        # symlink Windows Terminal settings
        EnsureFileSymlink -sourceDirectory "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState" -linkName "settings.json" -destinationLocation "$PSScriptRoot\WindowsTerminal\settings.json"
    }
}

function EnsureFileSymlink([string]$sourceDirectory, [string] $linkName, [string] $destinationLocation) {
    Push-Location $sourceDirectory

    try {
        if (Test-Path $linkName) {
            Remove-Item $linkName
        }

        cmd /c mklink $linkName $destinationLocation
        if ($LASTEXITCODE -ne 0) {
            exit $LASTEXITCODE
        }
    }
    finally {
        Pop-Location
    }
}

Main
