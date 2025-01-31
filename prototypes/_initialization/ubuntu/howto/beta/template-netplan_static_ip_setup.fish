# 🧪 This code must be tested by a device.
## 📰 ?명령을 한 번에 실행하게 하게 ssh 연결이 끊어져도 실행되도록 바꿔야할듯.
# sudo netplan apply, echo "Stopping $service_to_stop...", echo "Starting $service_to_start..." 할 때 각각 1번씩 총 3 번 끊김.

# 📅 Written at 2024-11-24 14:57:47

: ' ✏️ Define the default renderer. Users can change it as needed.
    🧮 set renderer_choice networkd
    or
    🧮 set renderer_choice NetworkManager
'
sudo -v


set renderer_choice networkd


# Detect Ethernet and Wireless interface names
set ethernet_name (find /sys/class/net -mindepth 1 -maxdepth 1 -lname '*virtual*' -prune -o -printf '%f\n' | grep '^e')
set wireless_name (find /sys/class/net -mindepth 1 -maxdepth 1 -lname '*virtual*' -prune -o -printf '%f\n' | grep '^w')

# Check if interface names were found
if test -z "$ethernet_name" -o -z "$wireless_name"
    echo "Error: Unable to detect network interfaces. Check your hardware or configuration."
    exit 1
end

# Ensure Netplan is installed
if not type -q netplan
    echo "Netplan is not installed. Installing..."
    sudo apt update && sudo apt install -y netplan.io
end

# Ensure the /etc/netplan directory exists
if not test -d /etc/netplan
    echo "Creating /etc/netplan directory..."
    sudo mkdir -p /etc/netplan
end

# Define services for each renderer
set networkd_service systemd-networkd
set networkmanager_service NetworkManager


# Determine which service to start/stop based on renderer_choice

if test "$renderer_choice" = networkd
    set service_to_start $networkd_service
    set service_to_stop $networkmanager_service
else if test "$renderer_choice" = NetworkManager
    set service_to_start $networkmanager_service
    set service_to_stop $networkd_service
else
    echo "Error: Unknown renderer choice. Exiting."
    exit 1
end

: ' ❔ Netplan applies network settings by reading all YAML files in /etc/netplan
    Files are processed in ascending order based on their numeric prefix (e.g., 00- is applied before 01-).
    Use numeric prefixes like "00-" or "01-" for higher priority settings.
    Example: /etc/netplan/00-network-config.yaml
'
# ✏️ Define the output file path for the Netplan configuration
set netplan_config_file /etc/netplan/01-network-manager-all.yaml

# Users can modify the file path if necessary. For example:
# set netplan_config_file /custom/path/to/netplan-config.yaml

# Generate Netplan YAML configuration with corrected syntax
echo "Generating Netplan configuration..."
# ✏️ Customize your Netplan file configuration
echo "network:
  version: 2
  renderer: $renderer_choice
  ethernets:
    $ethernet_name:
      dhcp4: no
      dhcp6: no
      addresses:
        - 10.10.14.59/24
      routes:
        - to: default
          via: 10.10.14.254
      nameservers:
        addresses:
          - 203.248.252.2
          - 1.1.1.1
          - 8.8.8.8
  wifis:
    $wireless_name:
      dhcp4: no
      dhcp6: no
      addresses:
        - 10.10.14.79/24
      routes: []
      nameservers:
        addresses:  
          - 203.248.252.2
          - 1.1.1.1
          - 8.8.8.8
      access-points:
        \"embA\":
          password: \"embA1234\"
" | sudo tee $netplan_config_file >/dev/null

# Correct file permissions for the Netplan configuration file
sudo chmod 600 $netplan_config_file



# Verify the changes
echo "Verifying network configuration..."
ip addr show $ethernet_name
ip addr show $wireless_name

: ' ⚠️ If both systemd-networkd and NetworkManager are enabled, they are likely to conflict with each other.
    By default, only one network management tool should be active, and it must match the renderer specified in Netplan to ensure stable network functionality.
'

# After applying Netplan, handle service management
echo "Stopping $service_to_stop... and Starting $service_to_start..."


## Run nohup with multiple commands in background process 📅 2025-01-19 00:47:43
systemd-run --user --unit=custom-task --scope nohup fish -c "
  sudo systemctl stop $service_to_stop && \
  sudo systemctl disable $service_to_stop && \
  sudo systemctl start $service_to_start && \
  sudo systemctl enable $service_to_start
" >log.log 2>&1 &


## You can test the configuration by running: 🧮 sudo netplan try
#   %shell>
#     systemctl status $service_to_stop
#     systemctl status $service_to_start
# If already Netpaln service activated and configuration is changed,
#   %shell> sudo netplan apply


# Update sudo cache in order to use sudo in fish subprocess
sudo -v
