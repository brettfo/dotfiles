# TODO:
# C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -noe -c "&{Import-Module """C:\Program Files\Microsoft Visual Studio\2022\Preview\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"""; Enter-VsDevShell 0a8f6ece}"
# function invoke ([string] $batch) {
#     .((Split-Path -Parent -Path $PROFILE) + "\Invoke-Environment.ps1") '$batch'
# }

# $vsdir = "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise"
# invoke "$vsdir\Common7\Tools\VsDevCmd.bat"
# $msbuildPath = "$vsdir\MSBuild\Current\Bin"
# $devenvPath = "$vsdir\Common7\IDE"
# $cmakePath = "$vsdir\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin"
# $env:PATH = "$msbuildPath;$devenvPath;$cmakePath;$env:PATH"

Import-Module posh-git

function prompt {
    # posh-git takes way too long displaying the status for these repos
    $badPaths = @(
        "C:\devdiv\VS",
        "C:\Code\devdiv\VS",
        "D:\devdiv\VS",
        "E:\devdiv\VS",
        "E:\Code\devdiv\VS"
    )
    $displayPosh = $true
    $promptText = "[ $(get-location)"
    foreach ($p in $badPaths) {
        if ($(get-location).ToString().StartsWith($p, [System.StringComparison]::OrdinalIgnoreCase)) {
            $displayPosh = $false
        }
    }
    If ($displayPosh) {
        $promptText += "$(Write-VcsStatus)"
    }
    $promptText += " ]`n"
    If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        $promptText += "$ "
    }
    else {
        $promptText += "# "
    }

    return $promptText
}

function devenvp([parameter(ValueFromRemainingArguments = $True)][string[]] $args) {
    & "C:\Program Files\Microsoft Visual Studio\2022\Preview\Common7\IDE\devenv.exe" $args
}

function k([parameter(ValueFromRemainingArguments = $True)][string[]] $assemblyNames) {
    foreach ($assemblyName in $assemblyNames) {
        taskkill /f /im "$assemblyName.exe"
    }
}

function ci([parameter(ValueFromRemainingArguments = $True)][string[]] $args) {
    code-insiders $args
}

function kci() {
    k "Code - Insiders"
}

function root {
    $currentDir = Convert-Path .
    $candidateRoot = $currentDir
    while ((Split-Path -Parent $candidateRoot).Length -gt 3) {
        if (Test-Path (Join-Path $candidateRoot ".git")) {
            Set-Location $candidateRoot
            return
        }

        $candidateRoot = Split-Path -Parent $candidateRoot
    }
}
