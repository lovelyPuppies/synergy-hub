#!/usr/bin/env fish
# 📅 Written at 2024-11-13 14:30:23
: '
  ⚠️ Issues: Bug ; VNC get stuck at logo screen everytime I reboot jetson agx xavier with jetpack 5.0.2. ; https://forums.developer.nvidia.com/t/vnc-get-stuck-at-logo-screen-everytime-i-reboot-jetson-agx-xavier-with-jetpack-5-0-2/240204
    ➡️ solution; It requires dummy monitor settings in /etc/X11/xorg.conf

  ⚠️ "gvncviewer" in client not works even if vnc server operates well. 📅 2024-11-13 13:43:06
    from my experience
        ```fish
            gvncviewer 10.10.14.99:5900
            # >> Error: Unable to connect to 10.10.14.99:11800: Connection refused
            #     Failed to connect to server
        ```
    ➡️ solution; use othre VNc viewer like TigerVNC.
        🛍️ e.g.
            ```fish
            vncviewer nano19.local:5900
            ```
'
function on_interrupt
    echo -e "\nScript interrupted. Exiting..."
    # Kill all child processes in the same process group
    kill -- -$fish_pid
    exit 1
end
trap on_interrupt SIGINT


# It requires sudo permission
sudo -v


echo "❔ Enter password of VNC server (hidden input): "
echo "  🛍️ e.g. 'nano'"
read --silent vnc_password


## ▶️ Define a copy of fish_modules because it must operate as a standalone function.
# It relies on `gawk` to handle line-by-line text processing, making it necessary to ensure compatibility with standalone execution.

function prettify_indent_via_pipe
    awk '
      NR == 2 { indent = match($0, /[^ ]/) - 1 }
      NR > 1 { sub("^ {" indent "}", "") }
      NR == 1 { next }
      { gsub(/[[:blank:]]*$/, ""); print }
    '
end

# Install gawk for compatibility, as this function may require GNU Awk (gawk)
# for expected behavior. Use `awk --version` to check if GNU Awk is installed.
# Installing gawk will set awk to automatically call gawk, ensuring compatibility.
sudo apt install -y gawk



## Enable the VNC server to start each time you log in
cd /usr/lib/systemd/user/graphical-session.target.wants
sudo ln -s ../vino-server.service ./.



## Configure the VNC server
# Disable prompt for connection approval in VNC
gsettings set org.gnome.Vino prompt-enabled false

# Disable encryption requirement for VNC connections
gsettings set org.gnome.Vino require-encryption false


## Set a password to access the VNC server
# Replace thep assword with your desired password
gsettings set org.gnome.Vino authentication-methods "['vnc']"
gsettings set org.gnome.Vino vnc-password (echo -n $vnc_password | base64)



## ▶️ Insert a new key named "enabled" in the GNOME Vino schema configuration.
# This key enables remote desktop access via the VNC protocol.

# Check if the indented "enabled" key line exists in the GNOME Vino schema configuration file\
set gschema_file_path "/usr/share/glib-2.0/schemas/org.gnome.Vino.gschema.xml"
if not grep -q '<key name="enabled" type="b">' $gschema_file_path
    # Insert a new key named "enabled" in the GNOME Vino schema configuration
    # This key enables remote desktop access via the VNC protocol


    set replacement_text (echo '
    \ \ \ \ <key name="enabled" type="b">\
    \ \ \ \ \ \ <summary>Enable remote access to the desktop</summary>\
    \ \ \ \ \ \ <description>\
    \ \ \ \ \ \ \ \ If true, allows remote access to the desktop via the RFB\
    \ \ \ \ \ \ \ \ protocol. Users on remote machines may then connect to the\
    \ \ \ \ \ \ \ \ desktop using a VNC viewer.\
    \ \ \ \ \ \ </description>\
    \ \ \ \ \ \ <default>false</default>\
    \ \ \ \ </key>
    ' | prettify_indent_via_pipe | string split0)
    sudo sed -i "/<\/schema>/i $replacement_text" $gschema_file_path

    # Compile the GNOME schema files to apply any changes made to schema definitions
    # This command processes all schema files in the specified directory and updates the system's compiled schema cache
    sudo glib-compile-schemas /usr/share/glib-2.0/schemas
end

# Enable VNC access
gsettings set org.gnome.Vino enabled true

## default value of 'view-only' key is false
# cat /usr/share/glib-2.0/schemas/org.gnome.Vino.gschema.xml | grep -A 7 'view-only'




## ▶️ Install the Xorg dummy video driver to create a virtual display.
# This allows the X server to run even if there is no physical monitor attached.
sudo apt install xserver-xorg-video-dummy

# Create the configuration directory for Xorg if it doesn’t exist.
sudo mkdir -p /etc/X11/xorg.conf.d/

# Generate a new Xorg configuration file for the dummy display
# and write it to /etc/X11/xorg.conf.d/10-dummy.conf.
# This configuration:
# - Defines a dummy video device with specified video RAM (256MB).
# - Configures a virtual monitor with horizontal and vertical sync rates.
# - Sets the screen layout to use the dummy device with a resolution of 1920x1080.
# - Establishes a server layout named "DummyLayout" that uses this virtual display setup.
# This setup enables a headless system to run X11 applications as if a physical display is present.
echo '
Section "Device"
    Identifier "DummyDevice"
    Driver     "dummy"
    VideoRam   256000
EndSection

Section "Monitor"
    Identifier "DummyMonitor"
    HorizSync  28.0-80.0
    VertRefresh 48.0-75.0
EndSection

Section "Screen"
    Identifier "DummyScreen"
    Monitor    "DummyMonitor"
    Device     "DummyDevice"
    DefaultDepth 24
    SubSection "Display"
        Depth 24
        Modes "1920x1080"  # 🚣 Desired resolution can be set here
    EndSubSection
EndSection

Section "ServerLayout"
    Identifier "DummyLayout"
    Screen     "DummyScreen"
EndSection
' | sudo tee /etc/X11/xorg.conf.d/10-dummy.conf >/dev/null



## ▶️ Install x11vnc, a VNC server that shares the X11 session over the network.
sudo apt install x11vnc

# Create a systemd service file to run x11vnc at startup.
# The service:
# - Starts x11vnc on display :0, running indefinitely with a VNC port of 5900.
# - Uses the authentication from the ".Xauthority" file of the "jetson" user.
# - Automatically restarts on failure for reliability.
# - Ensures the service starts only after the graphical target (graphical interface) is loaded.
echo "[Unit]
Description=Start x11vnc at startup.
After=graphical.target

[Service]
ExecStart=/usr/bin/x11vnc -display :0 -forever -rfbport 5900 -auth /home/jetson/.Xauthority -loop
User=jetson
Restart=on-failure

[Install]
WantedBy=graphical.target
" | sudo tee /etc/systemd/system/x11vnc.service

# Reload systemd manager configuration to recognize the new service file.
sudo systemctl daemon-reload

# Start the x11vnc service immediately.
sudo systemctl start x11vnc

# Enable x11vnc to start automatically on system boot.
sudo systemctl enable x11vnc



## ▶️ Reboot the system so that the settings take effect
sudo reboot
