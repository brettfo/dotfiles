#!/usr/bin/pwsh

# write .gitconfig redirect
$thisPath = $PSScriptRoot -replace "\\","/"
"[include]`n    path = $thisPath/.gitconfig" | Out-File -FilePath "~/.gitconfig"
