#!/usr/bin/pwsh

# write .gitconfig redirect
"[include]`n    path = $PSScriptRoot/.gitconfig" | Out-File -FilePath "~/.gitconfig"
