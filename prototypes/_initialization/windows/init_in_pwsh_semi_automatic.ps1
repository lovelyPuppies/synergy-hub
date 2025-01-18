<#
.SYNOPSIS
    Initializes the pwsh environment

.DESCRIPTION
    🚧 Prerequsites
      - This script must be run in "pwsh" after install pwsh in Window "PowerSshell"
      - You may need to see expiration_date/subscriptions.yml (License key)

.NOTES
    Author: wbfw109
    Date: 📅 2024-11-21 22:41:14

.EXAMPLE
    ./init_in_pwsh_semi_atuomatic.ps1

#>

##### ▶️ Windows built-in settings
#### 🌱 WSL (default: Ubuntu) install 🔗 https://learn.microsoft.com/en-us/windows/wsl/install 
wsl --install
<#
  ✔️ %shell> shutdown /r /t 0
#>



#### 🌱 System
<# 🚧 In a Settings window,
System
  - Notifications
    - ✔️ Do not disturb
  - Multitasking
    - Show tabs from apps when snapping or pressing Alt + Tab
      - ✔️ Don't show tabs
#>


#### 🌱 Personalization
<# 🚧 In a Settings window,
Personalization
  - Colors
    - Choose your mode
      - ✔️ Dark
  - Taskbar
    - Taskbar behaviors
      - ✔️ Automatically hide the taskbar
      - When using multiple displays, show my taskbar apps on
        ✔️ Taskbar where window is open
#>

#### 🌱 Time & language
<# 🚧 In a Settings window,
Time & language - Language & region
  - Language
    - Korean - More Options - Language Options
        - Keyboards - Installed keyboards - Add a keyboard
          - ✔️ Microsoft IME
  # ✔️ and remains one keyboard for each Language
#>



#### 🌱 File Explorer
<# 🚧 In a File Explorer window,
View
  - Show
    - ✔️ File name extensions
    - ✔️ Hidden items
  - See more - Options
    - General - Privacy
      - ✖️ Show recently used files
      - ✖️ Show frequently used folders
      - ✖️ Show files from Office.com
#>







##### ▶️ Windows Packages not supported by Scoop package manager, that work well.

<#
  📦⚓ Bandiview ; https://en.bandisoft.com/bandiview/dl.php?web
  📦⚓ Logitech G Hub ; https://download01.logi.com/web/ftp/pub/techsupport/gaming/lghub_installer.exe
  📦⚓ Docker Desktop ; https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-win-amd64
  📦⚓ Office 365 ; https://go.microsoft.com/fwlink/?linkid=2264705&clcid=0x409&culture=en-us&country=us
  📦⚓ Tailsacle ; https://pkgs.tailscale.com/stable/tailscale-setup-latest.exe
    Notes
    -----
    Start Tailscale with Windows by running:
    reg import "$HOME\scoop\apps\tailscale\current\add-startup.reg"
  # Discord 55691
  📦⚓ Discord ; https://stable.dl2.discordapp.net/distro/app/stable/win/x64/1.0.9173/DiscordSetup.exe
    If I install it using the command "scoop install extras/discord", a new instance is initiated every time I run the Discord app. 📅 2024-12-07 15:54:23
    
#>

<#
📦⚓ Tartube ; https://github.com/axcore/tartube/releases
  https://github.com/axcore/tartube
  GUI front-end for youtube-dl, yt-dlp and other compatible video downloaders
  ❌ Do not install from Scoop (extras/tartube) 📅 2025-01-18 13:03:20
    Tartube installed from Scoop cannot use FFmpeg, even if FFmpeg is installed via Scoop.
    Additionally, the built-in FFmpeg installer in Tartube fails.
  ❌ Do not use "4K YouTube to MP3 Converter" ; https://www.4kdownload.com 📅 2024-12-31 11:04:59
    https://www.4kdownload.com/troubleshooting/troubleshooting-cant-activate-with-license-key/2
    * Activation limit reached problem
      Licenses are tied to the current OS setup. If you format or reinstall the OS, the license is lost and cannot be renewed easily.
      License renewal is cumbersome and may require purchasing a new key after exceeding activation limits.
        
  Settings      
    Tartube setup
      Tartube stores all of its downloads in one place
        - ✔️ E:\Tartube
      When saving in the database, Tartube makes a backup copy of its databse file (in case seomthing gose wrong)
        - ✔️ Make a new backup file every time the database is saverd
      Choose which downloader to use
        - ✔️ yt-dlp
      📰 Install and update downloader
        📝 Not works
      ✔️ Install FFmpeg
      Tartube adds vidoe to a database. If you don't need a database, you can use Classic Mode.
        ✔️ Always open Tartube at this tab

    Tartube
      # Settings for Video to Audio ; https://github.com/axcore/tartube/issues/38#issuecomment-573664336
      [Tab] Classic Mode
        - Open in Classic Mode menu
          - Edit downlod options...
            - [Tab] Name
              - ✔️ Show advanced download options
            - [Tab] Format
              - ✔️ List of preferred formats
                mp4
                m4a
                m4a 128k (DASH Audio)
            - [Tab] Post-processing
              - [Tab] General
                - Post processing options
                  - ✔️ Post-process vidoe files to convert them to audio-only files
        - Destination
          - ✔️ E:\Tartube\downloads

📦⚓ Musicbee ; https://getmusicbee.com/downloads/
  ❌ Do not install from Scoop (extras/musicbee) 📅 2025-01-18 13:03:20
    >>
      Installing 'musicbee' (3.5.8698) [64bit] from 'extras' bucket
      The remote server returned an error: (404) Not Found.
      URL https://files1.majorgeeks.com/6c3bcf93d7e4ff1a87bb079e23abeadb594ed026/multimedia/MusicBeePortable_3_5.zip is not valid

  Settings
    Menu - Select Skin - Dark
      - ✔️ Kandinsky dark
#>


#### 📦🌱 NVIDIA App ; https://us.download.nvidia.com/nvapp/client/11.0.1.163/NVIDIA_app_v11.0.1.163.exe
<# 🚧 In a NVIDIA Overaly (⌨️ Alt + Z),
  Settings 
    - Shortcut controls
      - General
        - Open/close the in-game overaly
          - ✔️ Ctrl + Alt + Shift + Z (default: Alt + Z)
      - Statistics monitor
        - Toggle statistics overlay on/off
          - ✔️ None (default: Alt + R)
        - Cycle through metrics shown
          - ✔️ None (default: Alt + Shift + R)
        - Toggle visibility
          - ✔️ None (default: Alt + Ctrl + R)
#>
<# 🚧 In a NVIDIA App,
  System
    - ✔️ set GSYNC, Monitors' Refresh Rate you want
#>






##### ▶️ Windows Packages supported by Scoop package manaegr
# Get the profile file path (For all Host like VS Code, Windows Terminal, etc.)
$profilePath = $PROFILE.CurrentUserAllHosts
# Create the file if it does not exist
if (-not (Test-Path $profilePath)) {
  New-Item -ItemType File -Path $profilePath -Force
  Write-Host "Profile file has been created: $profilePath"
}


# 🔗 Approved Verbs for PowerShell Commands ; https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands
function Update-Profile {
  param (
      [string]$ProfilePath = $PROFILE.CurrentUserAllHosts
  )

  if (Test-Path $ProfilePath) {
      Write-Host "Reloading the profile from $ProfilePath..."
      . $ProfilePath
      Write-Host "Profile has been reloaded successfully."
  } else {
      Write-Host "Error: Profile file does not exist at $ProfilePath." -ForegroundColor Red
  }
}


#### 🚧 Add Context into pwsh fop Scoop
### Define the unique comment for Scoop environment setup
$scoopUniqueComment = "# SCOOP_ENV_SETUP"
# Define the Scoop environment setup script (as text)
$scoopSetup = @"
$scoopUniqueComment
if (-not (`$env:SCOOP)) {
    `$env:SCOOP = `"$env:USERPROFILE\scoop`"
}
if (-not (`$env:Path -like `"*`$env:SCOOP\shims*`")) {
    `$env:Path += `";`$env:SCOOP\shims`"
}
`n`n
"@
# Append Scoop setup script to profile if not already present
if (-not (Get-Content $profilePath | Select-String -SimpleMatch $scoopUniqueComment)) {
    $scoopSetup | Add-Content -Path $profilePath
    Write-Host "Scoop path setup has been added to the profile."
    Update-Profile
} else {
    Write-Host "Scoop path setup is already present in the profile."
}


### Define the unique comment for PSModulePath in Scoop
$psModulePathUniqueComment = "# PS_MODULE_PATH_SETUP"
# Define the line to add
$psModulePathLine = @"
$psModulePathUniqueComment
`$env:PSModulePath += `";`$env:USERPROFILE\scoop\modules\`"
`n`n
"@
# Check if the PSModulePath line is already in the profile
if (-not (Get-Content $profilePath | Select-String -SimpleMatch $psModulePathUniqueComment)) {
    # Add the line to the profile
    $psModulePathLine | Add-Content -Path $profilePath
    Write-Host "PSModulePath setup has been added to the profile."
    Update-Profile
} else {
    Write-Host "PSModulePath setup is already present in the profile."
}


#### 🚧 Install git for adding to buckets like "extra", "versions"
scoop install git
<#
  Notes
  -----
  Set Git Credential Manager Core by running: "git config --global credential.helper manager"

  To add context menu entries, run '$HOME\scoop\apps\git\current\install-context.reg'

  To create file-associations for .git* and .sh files, run
  '$HOME\scoop\apps\git\current\install-file-associations.reg'
#>

#### scoop bucket add main  # the "main" bucket is ⚖️ default existing bucket.
scoop bucket add extras
scoop bucket add versions
scoop bucket add nerd-fonts


#### 🚧 pwsh module 🔪 gsudo ; https://gerardog.github.io/gsudo/
# It must be replaced when Official Support is released 🅱️ https://github.com/microsoft/sudo?tab=readme-ov-file
scoop install main/gsudo
<#
  Notes
  -----
  gsudo has a PowerShell module that adds `gsudo !!` to elevate the last
  command.
  Use the module by running: 'Import-Module gsudoModule'.
  Add it to your $PROFILE to make it permanent.
#>
### Define the unique comment for gsudo in Scoop
$gsudoUniqueComment = "# Gsudo_MODULE_SETUP"
# Define the lines to add
$gsudoLines = @"
$gsudoUniqueComment
# Import gsudo module for elevating the last command with `gsudo !!`
Import-Module gsudoModule
`n`n
"@
# Check if the gsudo lines are already in the profile
if (-not (Get-Content $profilePath | Select-String -SimpleMatch $gsudoUniqueComment)) {
    # Add the lines to the profile
    $gsudoLines | Add-Content -Path $profilePath
    Write-Host "Gsudo import lines have been added to the profile."
    Update-Profile
} else {
    Write-Host "Gsudo import lines are already present in the profile."
}

##### 🌱 ... 



scoop install main/gdrive
scoop install extras/vcxsrv
scoop install extras/bandizip
scoop install extras/potplayer
scoop install extras/okular
scoop install extras/gimp
scoop install extras/rufus
scoop install extras/digikam # https://www.digikam.org/
scoop install extras/kakaotalk


scoop install extras/powertoys
<#
  - ✔️ customize FancyZone

  Notes
  -----
  Add PowerToys context menu option by running:
  Invoke-Expression -Command "$HOME\scoop\apps\powertoys\current\install-context.ps1"

  If an error occurs when updating or uninstalling, execute the following command then retry:
  `Stop-Process -Name 'explorer'`
#>

scoop install versions/steam
<#
  'steam' (nightly-20241118) was installed successfully!                                                                  
  Notes
  -----
  ❔ Changing Steam library folder is HIGHLY recommended.
#>



#### 🌱 Video, Audio
scoop install main/yt-dlp
scoop install versions/ffmpeg-yt-dlp
<# ...
  Creating shim for 'ffmpeg'.
  Creating shim for 'ffplay'.
  Creating shim for 'ffprobe'.
  #>




#### 🌱 Nerd Font
scoop install nerd-fonts/JetBrainsMono-NF-Mono
<#
  ✔️ and run file: "prototypes/_initialization/windows/font-set_personal_font.reg"
    📰🧪 It seems that the registry not render properly.
    
    📝 You can Check installed font name in 🛣️ Settings - Personalization - Fonts
    📝 You may need to reboot PC later.

  Reference
    - JetBrains Mono (not Nerd Font); https://github.com/JetBrains/JetBrainsMono
    - Nerd Font ; https://www.nerdfonts.com/font-downloads
    - Font comparation ; https://blog.hkwon.me/hkwon-programming-fonts/ (2019)
#>




#### 🌱 Visual Studio Code (VS Code)
scoop install extras/vscode
<#
  - ✔️ Activate settings-sync ; https://code.visualstudio.com/docs/editor/settings-sync
  - ✔️ copy "prototypes/_initialization/.vscode/_user-settings.jsonc" to user settings
    and change for "🌴 Windows dedicated and User-specific settings"

  Notes
  -----
  Add Visual Studio Code as a context menu option by running:
  'reg import "$HOME\scoop\apps\vscode\current\install-context.reg"'
  For file associations, run:
  'reg import "$HOME\scoop\apps\vscode\current\install-associations.reg"'
#>

  






#### 🌱 Network settings

### Enable Hyper-V using PowerShell ; https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v 📅 2024-12-07 05:24:56
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
Write-Host "❗ Requires to reboot Windows ; run in pwsh 🧮 Restart-Computer"



### Configures a bridged network for WSL2 to share the same network range as Windows. 
# https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/connect-to-network
#   This involves creating an external virtual switch in Hyper-V, linking it to a specified network adapter, 
#   and updating WSL2's configuration to use the bridged mode.
# 🚧 Prerequisite: Enable Hyper-V

## Create a Virtual Switch with Hyper-V Manager
<# Same Process if in GUI
  - Hypver-V Manager
    - Hyper-V Manager - 🏁 Home
      - Actions - 🏁 Virtual Switch Manager
        - Virtual Switchers - 🏁 New virtual network switch
          - Create virtual switch - 🏁 External
            - 🏁 Create Virtual Switch
        - New Virtual Switch
          - Name change to 🏁 wsl2-external
          - 🏁 External Network
      - 🏁 Apply
#>
# Use Get-NetAdapter to return a list of network adapters connected to the Windows system.
Get-NetAdapter
# Select the network adapter to use with the Hyper-V switch and place an instance in a variable named $net.
$net = Get-NetAdapter -Name 'Ethernet'
$switch_name = "wsl2-external"
New-VMSwitch -Name $switch_name -AllowManagementOS $True -NetAdapterName $net.Name

# Link it to a specified network adapter to WSL2
@"
[WSL2]
networkingMode = bridged
vmSwitch = wsl2-external
"@ | Set-Content -Path "$env:USERPROFILE\.wslconfig"

# Write-Host "❕ Requires to reboot WSL; run in pwsh 🧮 wsl --shutdown"
wsl --shutdown


