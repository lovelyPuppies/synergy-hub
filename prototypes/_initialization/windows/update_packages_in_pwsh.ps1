# Written at 📅 2024-12-18 00:58:42

# 📝 Before running this script, make sure that **PowerToys** and **VSCode** are not running.
#   These applications may be in use, and updating them while running could cause issues with the update process.
# 📝 And If you want to update "nerd-fonts", you must be restart as "Safe mode with Networking"


# 1. Get the list of installed packages
$installedApps = scoop list

# 2. Filter out the packages that are from the 'nerd-fonts' source
# Nerd-fonts packages are excluded because, on Windows, they are used as system packages and cannot be updated or removed unless in safe mode, as they may be in use otherwise.
$appsToUpdate = $installedApps | Where-Object { $_.Source -ne 'nerd-fonts' } | Select-Object -ExpandProperty Name

# 3. Update the packages that are not from 'nerd-fonts' source
foreach ($app in $appsToUpdate) {
    if ($app -eq 'tailscale') {
        Write-Host "Updating $app with sudo..."
        sudo scoop update $app  # Run `sudo` for tailscale
    } else {
        Write-Host "Updating $app..."
        scoop update $app  # Regular update for other apps
    }
}

Write-Host "Update process completed for non-nerd-fonts packages."
