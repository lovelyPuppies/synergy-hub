#!/usr/bin/env fish

##### init_nfs-client_to_server.fish
# 🪱 NFS (Network File System) allows for file sharing between Unix/Linux systems.
# This script configures an NFS client by dynamically taking user input for target details.
# Written at 📅 2024-12-11 11:00:20

: '
* Prerequisite
%shell> sudo apt update && sudo apt install -y nfs-common
'

### 1. Prerequisites and Initial Setup
# This step ensures necessary permissions and verifies if the required package is installed.

# Handle SIGINT (Ctrl+C) to exit the script gracefully
function on_interrupt
    echo -e "\nScript interrupted. Exiting..."
    kill -- -$fish_pid
    exit 1
end
trap on_interrupt SIGINT

# Require sudo permissions
sudo -v

# Ensure nfs-common is installed
if not type -q mount.nfs
    echo "nfs-common is not installed. Installing..."
    sudo apt update && sudo apt install -y nfs-common
else
    echo "nfs-common is already installed."
end

# Add a blank line for readability
echo ""

### 2. Collect user inputs
echo "❔ Enter the NFS server IP address:"
echo "  🛍️ e.g. '10.10.14.19', '10.10.14.40'"
read nfs_remote_host

echo "❔ Enter the NFS export directory on the server:"
echo "  🛍️ e.g. '/nfs', '/srv/lect_nfs'"
read nfs_remote_dir

echo "❔ Enter the local mount point directory (located in /mnt/):"
echo "  🛍️ e.g. 'host', 'lect_nfs'"
read local_mount_dir_name
set local_mount_dir /mnt/{$local_mount_dir_name}

# Create the local directory
mkdir --parents $local_mount_dir
echo "Your local mount folder is $local_mount_dir."

### 3. Mount the NFS share
echo "Attempting to mount $nfs_remote_host:$nfs_remote_dir to $local_mount_dir..."
sudo mount $nfs_remote_host:$nfs_remote_dir $local_mount_dir

# Check if the mount succeeded
if test $status -eq 0
    echo "Mount successful."
else
    echo "Error: Failed to mount $nfs_remote_host:$nfs_remote_dir. Exiting..."
    exit 1
end

### 4. Add to /etc/fstab for automatic mounting
echo "Configuring /etc/fstab for automatic mounting at boot..."

set fstab_line "$nfs_remote_host:$nfs_remote_dir $local_mount_dir nfs defaults,_netdev,soft,retry=1,x-systemd.automount,rsize=8192,wsize=8192,timeo=5,intr,x-gvfs-show 0 0"


if not grep --quiet --fixed-strings "$fstab_line" /etc/fstab
    echo "$fstab_line" | sudo tee -a /etc/fstab >/dev/null
    echo "Line added to /etc/fstab."
    echo "Reloading systemd to apply changes..."
    sudo systemctl daemon-reload
else
    echo "Configuration already exists in /etc/fstab. Skipping."
end

### 5. Mount all entries from fstab
echo "Ensuring all shares are mounted..."
sudo mount -a

if test $status -eq 0
    echo "NFS share is successfully configured and mounted."
else
    echo "Error: Failed to mount NFS share using /etc/fstab."
    exit 1
end
