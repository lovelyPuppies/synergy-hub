<#
.SYNOPSIS
    Initializes the PowerShell environment by setting execution policies and installing Scoop.

.DESCRIPTION
    This script configures the PowerShell execution policy for the current user and installs the Scoop package manager.
    It is designed to be the starting point for configuring a user-friendly PowerShell environment.

.NOTES
    Author: wbfw109
    Date: 📅 2024-11-17 19:00:54

.EXAMPLE
    ./init_in_pwsh.ps1
#>

### Set PowerShell Execution Policy for the current user
Write-Host "Setting ExecutionPolicy to RemoteSigned for CurrentUser..." -ForegroundColor Cyan
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

### Check if Winget is installed
# WinGet availability conditions: from 🔗 https://learn.microsoft.com/en-us/windows/package-manager/winget/
#   - Supported on Windows 10 1709 (build 16299) or later, Windows 11, and Windows Server 2025 or later.
#   - Requires Microsoft Store to be active.
#   - Included by default as part of the App Installer component on Windows 11.
#     App Installer is installed and updated via Microsoft Store.
#     Activation occurs after the first user login.
Write-Host "Checking if Winget is installed..." -ForegroundColor Cyan
if (-Not (Get-Command "winget" -ErrorAction SilentlyContinue)) {
    Write-Host "Winget is not installed on this system. Please install Winget first." -ForegroundColor Red
    exit 1
}


# Display Winget version
Write-Host "Winget version: $(winget --version)" -ForegroundColor Green

# Update Winget sources
Write-Host "Updating Winget package sources..." -ForegroundColor Cyan
winget source update
if ($?) {
    Write-Host "Winget package sources updated successfully!" -ForegroundColor Green
} else {
    Write-Host "Failed to update Winget package sources." -ForegroundColor Red
    exit 1
}






##### ⚓ App: Windows Terminal ; https://apps.microsoft.com/detail/9n0dx20hk701?hl=en-us&gl=kr
Write-Host "Installing Windows Terminal..." -ForegroundColor Cyan
winget install --id Microsoft.WindowsTerminal




##### ⚓ Scoop is a package manager for Windows that simplifies the installation of CLI tools ; https://scoop.sh/
Write-Host "Installing Scoop package manager..." -ForegroundColor Cyan
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression


##### pwsh ; https://github.com/PowerShell/PowerShell
scoop install pwsh

Write-Host "➡️ start 'pwsh' and follow 'init_in_pwsh_semi_atuomatic.ps1'"
<#
  Notes
  -----
  Since Scoop uses pwsh.exe internally, to update PowerShell Core itself,
  run `scoop update pwsh` from Windows PowerShell, i.e. powershell.exe.

  Add PowerShell Core as a explorer context menu by running:
  '$HOME\scoop\apps\pwsh\current\install-explorer-context.reg'
  For file context menu, run '$HOME\scoop\apps\pwsh\current\install-file-context.reg'
#>


##### Custom packages
# DotNet
scoop install main/dotnet-sdk
