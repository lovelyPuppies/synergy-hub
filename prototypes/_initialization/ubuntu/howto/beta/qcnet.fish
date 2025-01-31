#!/usr/bin/env fish
# 📅 Written at 2024-10-30 15:39:12
# ❗📰 TODO: Migrate to virsh.
# QEMU 에 명령어 인수 대신 줘서 사용하는것..
#   사용하기 매우 복잡하며, 특히 장기적으로 유지보수가 어려움..
#   사용자가 QEMU 내부 동작과 명령어 인수에 대해 높은 이해를 요구..
# - Previous files must be managed with version suffixes (e.g., 1.0).
# - Use virsh (libvirt library) for declarative management.
# - cloud-init and virsh .xml integration: The qcnet script should update the MAC address
#   based on user commands and normal usage.
# - For my personal computer used for development, it seems better to use virsh
#   rather than manual configuration.
## TODO  ???
# sudo apt update
# sudo apt install openvswitch-switch   // Open vSwitch (OVS)**
# sudo systemctl enable ovsdb-server.service
# sudo systemctl start ovsdb-server.service
# sudo systemctl status ovsdb-server.service
## TODO: "Video Streaming" https://www.spice-space.org/spice-user-manual.html

: '
qcnet; Utils of QEMU, Cloud-init and Network configuration

# https://gee6809.github.io/posts/qemu-network/
✈️ Purpose: Configure Bridge / Tap Network. not NAT (Network Address Translation).
                      +---------------------+ 
                      |   Host Machine      | 
                      |                     | 
                      |                     | 
                      |     +-----------+   | 
      LAN  --------------------- eth0   |   |       +-------------------+
(192.168.0.1)         |     |   tap0 ---------------|        VM0        |
                      |     |   tap1 ------------+  |  (192.168.0.3)    |
                      |     +-----------+   |    |  +-------------------+
                      |         br0         |    |
                      |    (192.168.0.2)    |    |  +-------------------+
                      |                     |    +--|        VM1        |
                      +---------------------+       |  (192.168.0.4)    |
                                                    +-------------------+
- 🪱 eth0: (con-name: $HOST_CONNECTION_NAME) - acts as a wrapper; identifies eth0 as part of the bridge connection (slave to br0)
- 🪱 br0: (bridge interface name: $HOST_BRIDGE_NAME) - the main bridge identifier with its own network settings
- Bridge acts like a virtual switch and connects networks together.
  - 📝 Taps and bridges must be created on the host machine.
    Tap serves to direct network data flow in another direction.


About 🪱 "connection.autoconnect yes"
    Enable autoconnect to ensure that this network connection is automatically activated whenever possible.
    This is crucial for persistent network setups, especially for bridge interfaces, as it ensures that the connection remains active even after system reboots.
    Without autoconnect, manual intervention would be required to bring the network up after each reboot.

$HOME/qemu/
├── .config                   # Shared configuration files for all VMs
│   └── network-config.yaml   # Common network configuration for cloud-init
├── .firmware                 # OVMF and other firmware files for UEFI boot
│   ├── OVMF_CODE_4M.secboot.fd
│   └── OVMF_VARS_4M.ms.fd
├── .vm_img                   # Storage for ISO and VM disk images
│   ├── ubuntu_22_desktop_amd64.iso
│   └── ubuntu_24_server_amd64.iso
├── vm_test_id                # Directory for each unique VM (created by user)
│   ├── ubuntu_22_desktop_amd64.qcow2      # Disk image for the VM
│   ├── cloud-init            # Cloud-init configuration files specific to this VM
│   │   ├── user-data.yaml    # Unique cloud-init user data for this VM
│   │   └── meta-data.yaml    # Unique cloud-init meta data for this VM
│   └── logs                  # Optional directory for VM logs
└── vm_test_id2               # Another example VM with a unique identifier
    ├── ubuntu_22_server_amd64.qcow2
    ├── cloud-init
    │   ├── user-data.yaml
    │   └── meta-data.yaml
    └── logs


'
# Handle SIGINT (Ctrl+C) to exit the script and terminate any child processes
function on_interrupt
    echo -e "\nScript interrupted. Exiting..."
    # Kill all child processes in the same process group
    kill -- -$fish_pid
    exit 1
end
trap on_interrupt SIGINT

# ──────────────────────────────────────────────────────────────────────
# Modules and utility imports
# 🔡 Snippet 📅 2024-11-13 09:11:09
set -l script_dir (dirname (realpath (status filename)))
# Load modules
source $script_dir/../../fish_modules/_import_all.fish



## Variables for network
set SERVICE_PREFIX qcnet-
set SERVICE_SUFFIX "-setup.service"
set HOST_CONNECTION_NAME $SERVICE_PREFIX"host-eth-br0"
set HOST_BRIDGE_NAME $SERVICE_PREFIX"host-br0"
set HOST_SERVICE_NAME $SERVICE_PREFIX"host"$SERVICE_SUFFIX
set DEFAULT_ETHERNET_INTERFACE_NAME (list_eth_interfaces)
set NETWORK_ID_TAP_NAME tap0
set SPICE_SOCK_DIR /run/user/1000
set SPICE_SOCK_NAME "spice.sock"


## Variables for vm
set CLOUD_INIT_DIR_NAME cloud-init
set CLOUD_INIT_ISO_NAME "cloud-init.iso"
set CLOUD_INIT_USER_DATA_NAME "user-data.yaml"
set CLOUD_INIT_META_DATA_NAME "meta-data.yaml"
set CLOUD_INIT_NETWORK_CONFIG_NAME "network-config.yaml"

set QEMU_VHD_EXT qcow2
set QEMU_DIR "$HOME/qemu"
mkdir -p $QEMU_DIR
set QEMU_CONFIG_DIR "$QEMU_DIR/.config"
mkdir -p $QEMU_CONFIG_DIR
# 🚣 Shared config between vm_id instances
set QEMU_CONFIG_CLOUD_INIT_DIR "$QEMU_CONFIG_DIR/$CLOUD_INIT_DIR_NAME"
mkdir -p $QEMU_CONFIG_CLOUD_INIT_DIR
set QEMU_CONFIG_NETWORK_FILE_PATH "$QEMU_CONFIG_CLOUD_INIT_DIR/$CLOUD_INIT_NETWORK_CONFIG_NAME"
set QEMU_CONFIG_DEFAULT_USER_DATA_PATH "$QEMU_CONFIG_CLOUD_INIT_DIR/$CLOUD_INIT_USER_DATA_NAME"
set QEMU_CONFIG_DEFAULT_META_DATA_PATH "$QEMU_CONFIG_CLOUD_INIT_DIR/$CLOUD_INIT_META_DATA_NAME"

set QEMU_FIRMWARE_DIR "$QEMU_DIR/.firmware"
mkdir -p $QEMU_FIRMWARE_DIR
set OVMF_CODE_4M_PATH "$QEMU_FIRMWARE_DIR/OVMF_CODE_4M.secboot.fd"
set OVMF_VARS_4M_PATH "$QEMU_FIRMWARE_DIR/OVMF_VARS_4M.ms.fd"

set QEMU_VM_IMG_DIR "$QEMU_DIR/.vm_img"
mkdir -p $QEMU_VM_IMG_DIR
set available_vm_imgs_path (ls $QEMU_VM_IMG_DIR)

set available_vm_ids_dir (find $QEMU_DIR -mindepth 1 -maxdepth 1 -type d ! -name '.*')
set available_network_ids (systemctl list-units --type=service --no-pager --plain | awk '{print $1}' | grep "^$SERVICE_PREFIX" | sed "s/^$SERVICE_PREFIX//;s/$SERVICE_SUFFIX\$//")


## VM-image index
# https://cloud-images.ubuntu.com/
set url_dist_ubuntu_24_server_amd64 https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
set url_dist_ubuntu_22_server_amd64 https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
set url_dist_ubuntu_22_desktop_amd64 https://releases.ubuntu.com/jammy/ubuntu-22.04.5-desktop-amd64.iso
set url_dist_ubuntu_24_desktop_amd64 https://mirror.siwoo.org/ubuntu-cd/24.04.1/ubuntu-24.04.1-desktop-amd64.iso


## Usage function: Display help message
function usage
    echo "Usage: qcnet.fish <main_command> <subcommands>..."
    echo "  📝 You must 'qcnet init' firstly once. and create vm instance by 'vm init.' ⭕ Recommend to see firstly 'guide' command"
    echo "Main Commands:"
    echo "  guide"
    echo ""
    echo ""
    echo "  host <action> <sub_action>"
    echo "    - action: One of 'file', 'network'"
    echo "    └ action: file"
    echo "      └ sub_action: init"
    echo "    └ action: network <sub_action>"
    echo "      └ sub_action: init (-a | --address) <addr> (-g | --gateway) <gateway> [(-d | --dns) <dns>]"
    echo "        - address: Host's ip4 address"
    echo "        - gateway: Host's ip4 gateway"
    echo "        - dns: Host's dns. 8.8.8.8, 1.1.1.1 are added automatically after you set or not set dns."
    echo "      └ sub_action: recover"
    echo ""
    echo ""
    echo "  vm init <vm_id> (-o | --os) <os> (-v | --version) <version> (-t | --type) <type> (-a | --arch) <arch> \\"
    echo "      (-s | --disk-size) <disk size (GiB)>"
    echo "    - vm_id: Virtual Machine ID (unique identifier for each VM instance)"
    echo "    - os: The operating system, e.g., 'ubuntu'"
    echo "    - version: OS version, e.g., '22'"
    echo "    - type: System type, e.g., 'desktop' or 'server'"
    echo "    - arch: Architecture, e.g., 'arm64', 'amd64'"
    echo "    - disk_size: Disk size of Virtual Hard Disk as GiB, e.g., '100', '150'"
    echo "  vm id <vm_id> (-r | --role) <role> <action> ..."
    echo "    - role: One of 'server', 'client'"
    echo "    └ role: server"
    echo "      └ action: set <property> <sub_action>"
    echo "        └ property: cloud-init"
    echo "          - sub_action: One of 'init', 'build'"
    echo "      └ action: run (-n | --network-id) <network_id>"
    echo "      └ action: stop"
    echo "    └ role: client"
    echo "      - action: One of 'run', 'stop'"
    echo "  vm list"
    echo "    Lists all vm_id created by this script. (It assumes from Path '$QEMU_DIR')"
    echo ""
    echo ""
    echo "  network init <network_id>"
    echo "    Initializes the network configuration for the specified network_id."
    echo "  network id <network_id> recover"
    echo "    Restores network configuration to its original state for the specified network_id."
    echo "  network check"
    echo "    Checks the status of all network services created by this script."
    echo "  network list"
    echo "    Lists all network services created by this script. (It assumes from services which start with '$SERVICE_PREFIX'"
    echo ""

end
function guide
    echo "📝  You must 'host file init', 'host network init' firstly once."
    echo "  ⚠️  To recover the host network, you must first tear down the network of other <vm_id> instances before running this command."
    echo ""
    echo "🛍️  e.g. Pipeline of qcnet (qcnet; Utils of QEMU, Cloud-init and Network configuration)"
    echo "  - . qcnet host file init"
    echo "  - . qcnet host network init -a 10.10.14.19/24 -g 10.10.14.254 -d 203.248.252.2"
    echo "  - . qcnet network init yocto_vm"
    echo "  - . qcnet vm id <vm_id> -r server set cloud-init ..."
    echo "    and You may need to configure the $QEMU_CONFIG_NETWORK_FILE_PATH file."
    echo "  - . qcnet vm id <vm_id> -r server run --network-id ..."
    echo "  - . qcnet vm id <vm_id> -r client run"

    echo "Examples:"
    echo "  . vm init yocto_vm -o ubuntu -v 22 -t desktop -a amd64"
    echo "  . vm id yocto_vm -r server run -n yocto_net-tap0"

end

# ──────────────────────────────────────────────────────────────────────
# "❗ There is no 'lazy evaluation' in fish shell. Undefined variables are have empty value. ''"
function verify_network_id --argument-name network_id
    for available_network_id in $available_network_ids
        if test $network_id = $available_network_id
            return
        end
    end
    exit 100
end
function initialize_variables_from_network_id --argument-name network_id
    : '
    It set global vars: service_name, service_path, tap_name
    🚧 Prerequisites
        [verify_network_id]
    ⚠️ Note that characters limit of network interface name is 15.
    '

    # ⏳ lazy evaluted 
    set -g service_name $SERVICE_PREFIX""$network_id""$SERVICE_SUFFIX; and set -g service_path "/etc/systemd/system/$service_name"; and set -g tap_name $network_id"-"$NETWORK_ID_TAP_NAME; or begin
        echo "❓ Error during initialize_variables_from_network_id()"; and exit 1
    end
    echo $service_path
end

function verify_vm_id --argument-name vm_id
    set vm_id_dir $QEMU_DIR/$vm_id
    if not test -e $vm_id_dir
        return 100
    end
end


# $ mkdir -p $vm_id_dir
function initialize_variables_from_vm_id --argument-name vm_id
    : 'It set global vars: vm_id_dir, [local_vhd_path, local_vhd_name]
    🚧 Prerequisites
        verify_vm_id
    '
    #  ⏳ lazy evaluted
    set -g vm_id_dir $QEMU_DIR/$vm_id; and set -g local_vhd_path (ls $vm_id_dir | grep "\.$QEMU_VHD_EXT\$" | head -n 1); and set -g local_vhd_name (echo $local_vhd_path | awk -F'/' '{print $NF}'); and set -g local_vhd_stem (string replace -r "\.$QEMU_VHD_EXT\$" '' $local_vhd_name)
    and set parts (string split "_" $local_vhd_stem); and set -g local_vhd_dist_type $parts[4]; and set -g local_vhd_dist_arch $parts[5]; and set -g local_vhd_cloud_init_dir $vm_id_dir/$CLOUD_INIT_DIR_NAME; and set -g local_vhd_cloud_init_iso_path $local_vhd_cloud_init_dir/$CLOUD_INIT_ISO_NAME; and set -g local_vhd_spice_sock_path $SPICE_SOCK_DIR"/$vm_id-"$SPICE_SOCK_NAME; and set -g local_vhd_spice_server_socket_path "spice+unix://"$local_vhd_spice_sock_path; or begin
        echo "❓ Error during initialize_variables_from_vm_id()"; and exit 1
    end

end
# ──────────────────────────────────────────────────────────────────────
## About Host
function initialize_shared_files
    : '
    https://www.qemu.org/download/#linux
      in host, requires qemu-system
    https://cloudinit.readthedocs.io/en/23.2.1/howto/predeploy_testing.html#qemu
      in qemu vm, requires cloud-utils
    https://ubuntu.com/core/docs/testing-with-qemu
      in host, requires ovmf
      ⚓ Open Virtual Machine Firmware (OVMF) ; https://wiki.ubuntu.com/UEFI/OVMF
    https://www.spice-space.org/spice-user-manual.html
      client, requires virt-viewer
    yq; parse yaml file

    '
    set -l packages qemu-system cloud-utils ovmf virt-viewer

    for package in $packages
        # Check if a package is installed
        if not dpkg --status $package >/dev/null 2>&1
            echo "$package is not installed. Installing..."
            sudo apt install -y $package
        else
            echo "$package is already installed."
        end
    end

    set -l packages_snap yq
    for package in $packages_snap
        # Check if a package is installed
        if type -q yq
            echo "$package is not installed. Installing..."
            sudo snap install $package
        else
            echo "$package is already installed."
        end
    end

    # Open Virtual Machine Firmware (OVMF) ; https://wiki.ubuntu.com/UEFI/OVMF
    echo "Copy OVMF firmware files for UEFI boot..."
    cp /usr/share/OVMF/OVMF_CODE_4M.secboot.fd $QEMU_FIRMWARE_DIR
    cp /usr/share/OVMF/OVMF_VARS_4M.ms.fd $QEMU_FIRMWARE_DIR

    echo "Writing default cloud-init files: user-data.yaml, meta-data.yaml, network-config.yaml ..."
    echo "📝 Note that only the $QEMU_CONFIG_NETWORK_FILE_PATH file is used across all user-defined <vm_id> instances."

    # Cloud-init Notes
    : '
    cloud-localds:
      - Cloud-init allows for local data source generation using the cloud-localds command.
      - This command creates a disk image containing user data and metadata for customization at boot.
      - Documentation: https://cloudinit.readthedocs.io/en/21.4/topics/faq.html#cloud-localds

    user-data.yaml:
      - This file allows customization of the instance at boot by specifying user data configurations.
      - Examples of configurations, such as setting passwords or enabling SSH, are available in the Cloud-init documentation:
        https://cloudinit.readthedocs.io/en/latest/reference/examples.html

    network-config.yaml (Network Config v2):
      - Cloud-init supports specifying network settings like IP addresses, gateways, and DNS through network-config.yaml.
      - Details on configuring networks can be found in the network config format v2 documentation:
        https://cloudinit.readthedocs.io/en/latest/reference/network-config-format-v2.html#network-config-v2

    ❔ Locked Passwords in Cloud-init:
      - The default password for the ubuntu user created by cloud-init is locked by default.
      - This is configured in /etc/cloud/cloud.cfg and means the user cannot log in by entering a password.
      - Issue reference for locked password: https://github.com/canonical/cloud-init/issues/4946

    ❔ SSH Key Login:
      - With a locked password, the default ubuntu account is accessible only via SSH key authentication.
      - Public SSH keys can be added through user-data.yaml, enabling access without needing a password.
      - Even with a locked password, SSH key access remains available, so users do not need to set or remember a password if they use SSH key-based login.
    '
    # 8.8.8.8, 1.1.1.1, 203.248.252.2
    echo '
    network:
      version: 2
      ethernets:
        ### 📝 Note: When "match: macaddress ..." is used, the ethernet name "enp0s2" is ignored.
        ##  📍 Therefore, my script will set the ethernet name as <vm_id> defined by the user, which is not the standard usage.
        # ➡️ You must assign new <vm_id> and configure network if you want to use vm with network.
        vm_test_id:
          # 🚣 fix address by MAC address
          match:    
            macaddress: "52:54:00:12:34:56"
          # wakeonlan: true
          dhcp4: false
          addresses:
            - 10.10.14.39/24
          gateway4: 10.10.14.254
          nameservers:
            addresses: [1.1.1.1., 8.8.8.8, 203.248.252.2]

    # ❔ Usage; %shell> cloud-localds cloud-init.iso user-data.yaml meta-data.yaml --network-config=network-config.yaml
    ' | prettify_indent_via_pipe | tee $QEMU_CONFIG_NETWORK_FILE_PATH >/dev/null

    echo '
    # meta-data.yaml
    instance-id: ubuntu-vm-instance
    local-hostname: ubuntu-vm
    ' | prettify_indent_via_pipe | tee $QEMU_CONFIG_DEFAULT_META_DATA_PATH >/dev/null

    echo '
    #cloud-config
    users:
      - name: ubuntu
        gecos: wbfw109v2
        primary_group: ubuntu
        groups: users, sudo
        lock_passwd: false
        shell: /usr/bin/fish
        # openssl passwd -6 ubuntu
        sudo: ["ALL=(ALL) NOPASSWD: ALL"]
        passwd: $6$aGVAnrypl.6vF9wV$iDikySUyNo69SRfMcV7GlqkwLu.BaXGR2YQnpzua9tTdDKQMp1.zRMsDKmLYNC.vm6x.084gJnVBvRYSRZ9n.0
        # ssh_authorized_keys:
        #   - ssh-rsa ... wbfw109v2@gmail.com

      - name: admin
        gecos: wbfw109v2
        primary_group: admin
        groups: admin, users
        lock_passwd: false
        # openssl passwd -6 admin
        passwd: $6$qYUOlf2vfzdo26Vs$9PW1h/8RVfS.nkJdqJYukxNyvAxW83MG0RsnKCQB9sORma3fXaKyrewqNVvqGueH3YfWTZuHbxoGelYdELaUR0
        shell: /bin/bash

        
    packages:
      - curl
      - git
      - openssh-server
      - smbclient
    runcmd:
      # Install fish shell and set as default if successful
      - sudo apt-add-repository ppa:fish-shell/release-3 -y && sudo apt update && sudo apt install -y fish && chsh -s $(which fish) && echo "✅ Fish shell installation completed successfully."
      # Configure automatic login for the ubuntu desktop account
      - if [ -f /etc/gdm3/custom.conf ]; then sudo sed -i \'s/^AutomaticLogin=.*/AutomaticLogin=ubuntu/\' /etc/gdm3/custom.conf && echo "✅ Successfully changed the automatic login account to ubuntu in Ubuntu desktop."; fi
      # Install Helix text editor
      - sudo snap install helix --classic && echo "✅ Helix installation completed successfully."
      # Enable and start the SSH service
      - sudo systemctl enable ssh && sudo systemctl start ssh && echo "✅ SSH service enabled and started successfully."


    final_message: "Cloud-init finished successfully"


    # 📝 Note that "#cloud-config" must be located at first line.
    # 📝 Whenever you change this,
    #   - To run "sudo cloud-init clean" in VM is required.
    #   - To run "cloud-localds cloud-init.iso user-data.yaml meta-data.yaml --network-config=network-config.yaml" in Host and to quit qemu is required.
    #   - To re-run qemu command is required
    #
    # check status with command
    #   🧮 sudo cat /var/log/cloud-init.log.
    #   🧮 sudo cat /var/log/cloud-init-output.log
    #   🧮 sudo cloud-init clean --logs
    #   🧮 cloud-init status
    ' | prettify_indent_via_pipe | tee $QEMU_CONFIG_DIR/$CLOUD_INIT_USER_DATA_NAME >/dev/null

end



# ──────────────────────────────────────────────────────────────────────
## VM-related functions



# ──────────────────────────────────────────────────────────────────────
# Main command verification

# 🔡 Snippet 📅 2024-11-04 21:15:06
exit_if_no_argument_from_argv1 $argv[1]
set main_command $argv[1]
set --erase argv[1]

if test $main_command != guide
    exit_if_no_argument_from_argv1 $argv[1]
    set sub_command $argv[1]
    set --erase argv[1]
end

switch $main_command
    case guide
        guide; and exit
    case host
        switch $sub_command
            case file
                exit_if_no_argument_from_argv1 $argv[1]
                set action $argv[1]
                set --erase argv[1]

                if test $action = init
                    initialize_shared_files
                else
                    usage; and exit 1
                end
            case network
                # 📍⚓ https://ahelpme.com/linux/centos-8/create-bridge-and-add-tun-tap-device-using-networkmanager-nmcli-under-centos-8/
                exit_if_no_argument_from_argv1 $argv[1]
                set action $argv[1]
                set --erase argv[1]

                switch $action
                    case init
                        argparse 'a/address=!test -n "$_flag_value"' \
                            'g/gateway=!test -n "$_flag_value"' \
                            'd/dns=!test -n "$_flag_value"' \
                            -- $argv
                        or begin
                            echo "❓ Error: Invalid arguments for init command."
                            exit 1
                        end
                        # Check if required options are provided
                        if not set -q _flag_address; or not set -q _flag_gateway
                            echo "❓ Error: Two options (-a, -g) are required for host network init."
                            exit 1
                        end

                        # Optional argument
                        if not set -q _flag_dns
                            set _flag_dns "8.8.8.8,1.1.1.1"
                        else
                            set _flag_dns $_flag_dns",8.8.8.8,1.1.1.1"
                        end

                        echo "Setting-up Host's bridge network ..."
                        echo "📝 Be cautious if you are working remotely, as the connection may drop momentarily during this transition."

                        echo "Creating a bridge interface and defining the connection name for the bridge itself"
                        # Purpose: Defining the connection name ($HOST_BRIDGE_NAME) for the bridge interface
                        # Role: Providing a connection name to manage and modify the bridge interface's network settings
                        sudo nmcli connection add type bridge ifname $HOST_BRIDGE_NAME con-name $HOST_BRIDGE_NAME

                        echo "Setting static IP address, gateway, and DNS configurations for the bridge"

                        sudo nmcli connection modify $HOST_BRIDGE_NAME ipv4.addresses $_flag_address
                        sudo nmcli connection modify $HOST_BRIDGE_NAME ipv4.gateway $_flag_gateway
                        sudo nmcli connection modify $HOST_BRIDGE_NAME ipv4.dns $_flag_dns
                        sudo nmcli connection modify $HOST_BRIDGE_NAME ipv4.method manual
                        sudo nmcli connection modify $HOST_BRIDGE_NAME ipv4.ignore-auto-routes yes
                        sudo nmcli connection modify $HOST_BRIDGE_NAME ipv4.ignore-auto-dns yes
                        echo "Enabling autoconnect for the bridge interface on startup"
                        sudo nmcli connection modify $HOST_BRIDGE_NAME connection.autoconnect yes
                        sudo systemctl restart NetworkManager

                        echo "Adding Ethernet interface to the bridge and defining its connection name"
                        # Purpose: Defining the connection name for the Ethernet interface within the bridge
                        # Role: Adding the Ethernet interface ($DEFAULT_ETHERNET_INTERFACE_NAME) as a slave to the bridge
                        #       and assigning a connection name ($HOST_CONNECTION_NAME) for management
                        sudo nmcli connection add type ethernet slave-type bridge \
                            con-name $HOST_CONNECTION_NAME ifname $DEFAULT_ETHERNET_INTERFACE_NAME master $HOST_BRIDGE_NAME
                        echo "Enabling autoconnect for the Ethernet interface on startup"
                        sudo nmcli connection modify $HOST_CONNECTION_NAME connection.autoconnect yes
                        sudo systemctl restart NetworkManager

                        echo "Activating the bridge connection"
                        sudo nmcli connection up $HOST_CONNECTION_NAME


                        echo "Completed to setup Host network."
                        echo "  ➡️ You could configure <vm_id> network"
                        exit
                    case recover
                        : '
                        📰📅 2024-10-29 16:44:23
                            I am unable to solve the issue of deactivating and deleting a connection continuously without using explicit sleep commands.  
                            It appears to be caused by the asynchronous behavior of the `nmcli connection` command, which may not wait for the state change to complete before proceeding.
                            To use "--wait" argument not works well.
                        '
                        echo "Recovering network configuration for Host ..."
                        echo "Your bridge network info: "
                        nmcli -f ipv4.addresses,ipv4.gateway,ipv4.dns connection show $HOST_BRIDGE_NAME | awk '{print "  - " $0}'
                        echo "  ⚠️  To recover the host network, you must first tear down the network of other <vm_id> instances before running this command."
                        while true
                            echo "Do you want to proceed? (y/n)"
                            read --local confirmation
                            switch $confirmation
                                case y
                                    break

                                case n
                                    echo "Operation canceled. Exiting without changes."
                                    exit

                                case '*'
                                    echo "Invalid input. Please enter 'y' or 'n'."
                            end
                        end

                        # Deactivate the bridge connection
                        sudo nmcli connection down $HOST_CONNECTION_NAME
                        sleep 3

                        # Delete the Ethernet connection from the bridge
                        sudo nmcli connection delete $HOST_CONNECTION_NAME

                        # Deactivate and delete the bridge interface
                        sudo nmcli connection down $HOST_BRIDGE_NAME
                        sleep 3
                        sudo nmcli connection delete $HOST_BRIDGE_NAME

                        # Restart NetworkManager to ensure a clean state
                        sudo systemctl restart NetworkManager

                        echo "Completed to recover Host's bridge network"
                        exit
                    case '*'
                        usage; and exit 1
                end
            case '*'
                usage; and exit 1
        end
        exit
    case vm
        switch $sub_command
            case init
                exit_if_no_argument_from_argv1 $argv[1]
                set vm_id $argv[1]
                set --erase argv[1]

                # 🔡 Snippet 📅 2024-11-04 21:01:37
                argparse 'o/os=!test -n "$_flag_value"' \
                    'v/version=!test -n "$_flag_value"' \
                    't/type=!test -n "$_flag_value"' \
                    'a/arch=!test -n "$_flag_value"' \
                    's/disk-size=!test -n "$_flag_value"; and string match -r \'^[0-9]+$\' -- "$_flag_value"' \
                    -- $argv
                or begin
                    echo "❓ Error: Invalid arguments for init command."
                    exit 1
                end
                # Check if required options are provided
                if not set -q _flag_os; or not set -q _flag_version; or not set -q _flag_type; or not set -q _flag_arch; or not set -q _flag_disk_size
                    echo "❓ Error: All options (-o, -v, -t, -a, -s) are required for vm init."
                    exit 1
                end


                echo "▶️  Initializing VM with ID: $vm_id, OS: $_flag_os, Version: $_flag_version, Type: $_flag_type, Arch: $_flag_arch, VHD: $_flag_disk_size GiB ..."
                initialize_variables_from_vm_id $vm_id



                set vhd_stem "dist_"$_flag_os"_"$_flag_version"_"$_flag_type"_"$_flag_arch
                set vhd_name $vhd_stem.$QEMU_VHD_EXT
                set vhd_path $vm_id_dir/$vhd_name
                set user_input_url_dist "url_"$vhd_stem



                echo "Checking if the distrubition index exists ..."
                if not set -q (echo $user_input_url_dist)
                    echo "❓ Error: Not Found distribution url in index for '$user_input_url_dist'."
                    echo "  Please add manually distribution url index into this script file."
                    exit 1
                end


                echo "Checking if the distrubition image file exists ..."
                set -l is_matched 1
                for img_path in $available_vm_imgs_path
                    set -l file_name (echo $available_vm_imgs_path | awk -F'.' '{print $1}')
                    if test $vhd_stem = $file_name
                        set is_matched 0
                        break
                    end
                end

                echo "Checking if the distrubition image must be downloaded ..."
                set -l skip_download 1
                set -l target_img_file_url (eval echo $$user_input_url_dist)
                set -l dist_file_name $vhd_stem"."(echo $target_img_file_url | awk -F'.' '{print $NF}')
                set -l local_dist_file_path $QEMU_VM_IMG_DIR/$dist_file_name

                set -l local_dist_file_size (stat --format="%s" $local_dist_file_path)
                set -l remote_dist_size (wget --spider $target_img_file_url 2>&1 | grep "^Length" | awk '{print $2}')

                if test $is_matched -eq 0
                    echo "Found an image file. Checking for a newer version or an incomplete download ..."
                    echo "Compare Size local_dist_file_size: $local_dist_file_size, and remote_dist_size: $remote_dist_size ..."
                    if test $remote_dist_size = $local_dist_file_size
                        echo "Skip to download image."
                        set skip_download 0
                    end
                else
                    echo "Not Found image file."
                end

                if test $skip_download -eq 1
                    echo "Downloading image ..."
                    wget -O $local_dist_file_path $target_img_file_url
                end


                echo "Creating virtual disk and running Ubuntu VM..."
                ## ISO files are generally considered read-only media and cannot be modified.
                # They emulate CD/DVD images, so it is not possible to change or save data on them.
                # Therefore, if the VM is run with only an ISO file, any changes made will not persist after the VM is restarted.
                # To retain changes, a writable virtual disk file is required.
                # 🕥 Testing with Quick Emulator with virtual disk file ; https://ubuntu.com/server/docs/virtualisation-with-qemu
                # https://documentation.ubuntu.com/server/how-to/virtualisation/libvirt/
                # Ubuntu Core with QEMU Without TPM emulation

                set temp_local_vhds_name (ls $vm_id_dir | grep  "\.$QEMU_VHD_EXT\$" | awk -F'/' '{print $NF}')
                for temp_local_vhd_name in $temp_local_vhds_name
                    if test $temp_local_vhd_name != $vhd_name
                        echo "❓ Error: Another vhd file (.$QEMU_VHD_EXT) exists '$temp_local_vhd_name' in $vm_id_dir."
                        echo "  You are trying to create a VHD named $vhd_name, but Another vhd already exists."
                        exit 1
                    end
                end

                # Checking VHD file exists ...
                if test -e $vhd_path
                    while true
                        echo "⚠️  Warning: Found same name vhd file (.$QEMU_VHD_EXT) exists $vhd_path"
                        echo "  This process will overwrite $vhd_path and launch the VM."
                        echo "Do you want to proceed? (y/n)"
                        read --local confirmation
                        switch $confirmation
                            case y
                                break

                            case n
                                echo "Operation canceled. Exiting without changes."
                                exit

                            case '*'
                                echo "Invalid input. Please enter 'y' or 'n'."
                        end
                    end
                end
                echo "Proceeding with VM creation and initialization..."

                echo "Create the virtual disk file..."
                qemu-img create -f $QEMU_VHD_EXT $vhd_path $_flag_disk_size"G"

                echo "Launch the VM with the specified configuration..."
                set qemu_target_binary ""
                if test $_flag_arch = amd64
                    set qemu_target_binary qemu-system-x86_64
                    if test $_flag_type = desktop
                        $qemu_target_binary \
                            -enable-kvm -smp 1 -m 2048 -machine q35 -cpu host \
                            -global ICH9-LPC.disable_s3=1 \
                            -net nic,model=virtio \
                            # -net user # NAT with PortForwarding \
                            -net user,hostfwd=tcp::8022-:22,hostfwd=tcp::8090-:80 \
                            -drive file=$OVMF_CODE_4M_PATH,if=pflash,format=raw,unit=0,readonly=on \
                            -drive file=$OVMF_VARS_4M_PATH,if=pflash,format=raw,unit=1 \
                            -drive file=$vhd_path,if=none,id=disk0,format=$QEMU_VHD_EXT,cache=writeback \
                            -device virtio-blk-pci,drive=disk0,bootindex=0 \
                            -drive file=$local_dist_file_path,if=none,id=cdrom,media=cdrom \
                            -device ide-cd,bus=ide.1,drive=cdrom \
                            -serial mon:stdio
                    else
                        echo "❔  Unsupported type. Please add code for this type."
                        exit
                    end
                else
                    echo "❔  Unsupported architecture. Please add code for this architecture."
                    exit
                end

                echo "$vhd_path VHD initialized."
                exit
            case id
                ## Parse <vm_id>
                exit_if_no_argument_from_argv1 $argv[1]
                set vm_id $argv[1]
                set --erase argv[1]
                set vm_id_dir $QEMU_DIR/$vm_id


                verify_vm_id $vm_id
                if test $status -ne 0
                    echo "❓ Error: Not Found Valid vm_id. run 'vm list'"
                    exit 1
                end
                initialize_variables_from_vm_id $vm_id




                ## Parse role: server or client.
                argparse --ignore-unknown 'r/role=!test -n "$_flag_value"' -- $argv
                or begin
                    echo "❓ Error: Invalid arguments for id command."
                    exit 1
                end
                # Check if required options are provided
                if not set -q _flag_role
                    echo "❓ Error: Role ('server' | 'client') is required for vm init."
                    exit 1
                end

                exit_if_no_argument_from_argv1 $argv[1]
                set action $argv[1]
                set --erase argv[1]

                switch $_flag_role
                    case server
                        switch $action
                            case set
                                exit_if_no_argument_from_argv1 $argv[1]
                                set property $argv[1]
                                set --erase argv[1]

                                exit_if_no_argument_from_argv1 $argv[1]
                                set cloud_init_action $argv[1]
                                set --erase argv[1]

                                set cloud_init_path $vm_id_dir"/cloud-init"

                                if test $property = cloud-init
                                    switch $cloud_init_action
                                        case init
                                            if test -e $cloud_init_path
                                                while true
                                                    echo "⚠️  Warning: Found cloud-init directory in $vm_id_dir"
                                                    echo "  This process will overwrite $cloud_init_path/* files as default files"
                                                    echo "Do you want to proceed? (y/n)"
                                                    read --local confirmation
                                                    switch $confirmation
                                                        case y
                                                            break

                                                        case n
                                                            echo "Operation canceled. Exiting without changes."
                                                            exit

                                                        case '*'
                                                            echo "Invalid input. Please enter 'y' or 'n'."
                                                    end
                                                end
                                            end
                                            echo "Initializing cloud-init..."
                                            mkdir -p $cloud_init_path
                                            cp $QEMU_CONFIG_DIR/$CLOUD_INIT_USER_DATA_NAME $cloud_init_path/
                                            cp $QEMU_CONFIG_DIR/$CLOUD_INIT_META_DATA_NAME $cloud_init_path/
                                            echo "Cloud-init files initialized."
                                            echo "➡️  Run '... cloud-init build' to applay your vm image."
                                            exit
                                        case build
                                            echo "Building cloud-init..."
                                            pushd $cloud_init_path
                                            cloud-localds $CLOUD_INIT_ISO_NAME $CLOUD_INIT_USER_DATA_NAME $CLOUD_INIT_META_DATA_NAME --network-config=$QEMU_CONFIG_NETWORK_FILE_PATH
                                            echo "Completed building $CLOUD_INIT_ISO_NAME"
                                            popd
                                            exit
                                        case '*'
                                            usage; and exit
                                    end
                                else
                                    usage; and exit 1
                                end

                            case run
                                argparse 'n/network-id=!test -n "$_flag_value"' -- $argv
                                or begin
                                    echo "❓ Error: Invalid arguments for server run command."
                                    exit 1
                                end
                                # Check if required options are provided
                                if not set -q _flag_network_id
                                    echo "❓ Error: Network ID (-n or --network-id) is required for 'server run' command."
                                    exit 1
                                end

                                verify_network_id $network_id
                                if test $status -ne 0
                                    echo "❓ Error: Not Found Valid network_id. run 'network list'"
                                    exit 1
                                end
                                initialize_variables_from_network_id $network_id


                                echo "Checking VHD Distribution type (server | desktop) ..."
                                if test $local_vhd_dist_type = desktop
                                    echo "..."
                                else if test $local_vhd_dist_type = server
                                    echo "❔  Unsupported type. Please add code for this type."
                                    exit
                                else
                                    echo "❔  Unsupported type. Please add code for this type."
                                    exit
                                end

                                echo "Checking VHD Distribution architecture ..."
                                if test $local_vhd_dist_arch = amd64
                                    set qemu_target_binary qemu-system-x86_64
                                else
                                    echo "❔  Unsupported architecture. Please add code for this architecture."
                                    exit
                                end


                                # Find Network config
                                set cloud_init_macaddress (cat $QEMU_CONFIG_NETWORK_FILE_PATH | yq ".network.ethernets.$vm_id.match.macaddress")
                                if test $cloud_init_macaddress = null
                                    echo "❓  Not found field .network.ethernets.$vm_id.match.macaddress in file '$QEMU_CONFIG_NETWORK_FILE_PATH'."
                                    exit 1
                                end

                                $qemu_target_binary \
                                    -enable-kvm \
                                    -smp 1 \
                                    -m 2048 \
                                    -machine q35 \
                                    -cpu host \
                                    -netdev tap,id=net0,ifname=$tap_name,script=no,downscript=no \
                                    -device virtio-net-pci,netdev=net0,mac=$cloud_init_macaddress \
                                    -global ICH9-LPC.disable_s3=1 \
                                    -drive file=$OVMF_CODE_4M_PATH,if=pflash,format=raw,unit=0,readonly=on \
                                    -drive file=$OVMF_VARS_4M_PATH,if=pflash,format=raw,unit=1 \
                                    -cdrom $local_vhd_cloud_init_iso_path \
                                    -boot d \
                                    -drive file=$local_vhd_path,if=none,id=disk0,format=qcow2,cache=writeback \
                                    -device virtio-blk-pci,drive=disk0,bootindex=1 \
                                    ## Spice ~
                                    -spice disable-ticketing=on \
                                    # GL acceleration (virgl). you can not use '-spice port=3001,disable-ticketing=on' and 'remote-viewer spice://localhost:3001'.
                                    -device virtio-vga-gl -spice gl=on,unix=on,addr=$local_vhd_spice_sock_path \
                                    # Spice 🔪 Multiple monitor support. if you want to, add '-device qxl'
                                    -vga qxl \
                                    # Spice 🔪 Agent
                                    -device virtio-serial \
                                    -chardev spicevmc,id=vdagent,debug=0,name=vdagent \
                                    -device virtserialport,chardev=vdagent,name=com.redhat.spice.0 \
                                    #📰 Spice 🔪 USB redirection
                                    -device qemu-xhci,id=usb \
                                    -chardev spicevmc,name=usbredir,id=usbredirchardev1 \
                                    -device usb-redir,chardev=usbredirchardev1,id=usbredirdev1 \
                                    -chardev spicevmc,name=usbredir,id=usbredirchardev2 \
                                    -device usb-redir,chardev=usbredirchardev2,id=usbredirdev2 \
                                    -chardev spicevmc,name=usbredir,id=usbredirchardev3 \
                                    -device usb-redir,chardev=usbredirchardev3,id=usbredirdev3 \
                                    ## Run in Forground or Background: [-serial mon:stdio, -daemonize]
                                    -daemonize
                                #📰 Spice 🔪 TLS
                                #📰 Spice 🔪 Intel’s GVTg
                                #📰 Spice 🔪 Video Streaming
                                ## will be reload spice...
                                # -device qemu-xhci,id=xhci \
                                #-device usb-host,bus=xhci.0,hostbus=$bus_id,hostaddr=$device_id

                            case stop
                                echo "Stopping QEMU server for VM ID: $vm_id..."

                                # Get the process ID of the running QEMU server
                                set qemu_server_pid (pgrep -f 'qemu.*-drive file='"$local_vhd_path"',if=none,id=disk0,format=qcow2,cache=writeback')

                                # Check if the process exists
                                if test -n "$qemu_server_pid"
                                    echo "QEMU server process found. Terminating..."
                                    echo $qemu_server_pid | xargs kill
                                    echo "Process terminated successfully."
                                else
                                    echo "❔ No matching QEMU server process found."
                                    exit
                                end

                            case '*'
                                usage; and exit 1
                        end

                    case client
                        switch $action
                            case run
                                echo "Running client for VM ID: $vm_id..."

                                if test $local_vhd_dist_type = desktop
                                    echo "Connecting to the desktop VM via SPICE server socket at $local_vhd_spice_server_socket_path"
                                    remote-viewer $local_vhd_spice_server_socket_path
                                else
                                    echo "❔ Unsupported VM type '$local_vhd_dist_type'. Please add handling code for this type."
                                    exit
                                end

                            case stop
                                echo "Stopping client for VM ID: $vm_id..."

                                if test $local_vhd_dist_type = desktop
                                    echo "Stopping SPICE client associated with VM ID: $vm_id..."

                                    # Get the process ID of the running remote-viewer
                                    set qemu_client_pid (pgrep -f "remote-viewer $local_vhd_spice_server_socket_path")

                                    # Check if the process exists
                                    if test -n "$qemu_client_pid"
                                        echo "SPICE client process found. Terminating..."
                                        echo $qemu_client_pid | xargs kill
                                        echo "Process terminated successfully."
                                    else
                                        echo "❔ No matching process found."
                                    end
                                else
                                    echo "❔ Unsupported VM type '$local_vhd_dist_type' for stopping process."
                                end

                            case '*'
                                usage; and exit 1
                        end

                    case '*'
                        usage; and exit 1
                end
            case list
                echo "❔ Listing all vm id created by this script:"
                # NF: Number of Fields
                for available_vm_id_dir in $available_vm_ids_dir
                    set -l vm_dist_name (ls $available_vm_id_dir | grep "\.$QEMU_VHD_EXT\$" | string replace -r '^dist_' '' | awk -F'/' '{print $NF}')
                    set -l vm_dist_name (basename $vm_dist_name .$QEMU_VHD_EXT)

                    echo $available_vm_id_dir | awk -F/ '{print " - " $NF}'
                    echo "  dist: $vm_dist_name"
                end
                exit
        end

    case network
        switch $sub_command
            case init
                exit_if_no_argument_from_argv1 $argv[1]
                set network_id $argv[1]
                set --erase argv[1]

                echo "Initializing network with ID: $network_id"
                initialize_variables_from_network_id $network_id
                echo "$tap_name"

                echo "Creating TAP setup service..."


                echo "
                [Unit]
                Description=TAP Interface Setup Service
                # Ensure the service starts only after basic network is ready and NetworkManager is active.
                After=network.target NetworkManager.service
                # Prefer to run this service when the network is fully online, but it's not mandatory.
                Wants=network-online.target

                [Service]
                Type=oneshot

                # 📝 Note: No need to manually bring up '$HOST_BRIDGE_NAME', as activating it automatically handles the bridge interface activation.
                ExecStart=/usr/bin/env bash -c ' \\
                    nmcli connection up $HOST_BRIDGE_NAME && \\
                    ip tuntap add dev $tap_name mode tap user $(whoami) && \\
                    ip link set $tap_name master $HOST_BRIDGE_NAME && \\
                    ip link set $tap_name up \\
                '
                ExecStop=/usr/bin/env bash -c ' \\
                    ip link set $tap_name down && \\
                    ip tuntap del dev $tap_name mode tap \\
                '
                RemainAfterExit=yes

                [Install]
                WantedBy=multi-user.target

                # ❔ About 'ExecStart'
                #   1. Activate the bridge connection
                #     %shell> nmcli connection up $HOST_BRIDGE_NAME
                #   2. Create a TAP interface
                #     %shell> ip tuntap add dev $tap_name mode tap user $(whoami)
                #   
                #   3. Attach the TAP interface to the bridge
                #     %shell> ip link set $tap_name master $HOST_BRIDGE_NAME
                #   4. Activate the TAP interface
                #     It may take up to 10 seconds for the TAP interface to initialize inside a VM.
                #     %shell> ip link set $tap_name up

                # ❔ About 'ExecStop'
                #   1. Deactivate the TAP interfac
                #     %shell> ip link set $tap_name down
                #   2. Delete the TAP interface
                #     %shell> ip tuntap del dev $tap_name mode tap
                
                # journalctl -u $service_name -f


                " | prettify_indent_via_pipe | sudo tee $service_path

                echo "Reloading systemd and enabling the TAP service..."
                echo "Enable service and start $service_name"
                sudo systemctl daemon-reload
                sudo systemctl enable $service_name
                sudo systemctl start $service_name

                echo "$service_name started and enabled successfully."
                exit
            case id
                ## Parse <network_id>
                exit_if_no_argument_from_argv1 $argv[1]
                set network_id $argv[1]
                set --erase argv[1]


                # Verify and Initialize variables for <network_id>
                verify_network_id $network_id
                if test $status -ne 0
                    echo "❓ Error: Not Found Valid network_id. run 'network list'"
                    exit 1
                end
                initialize_variables_from_network_id $network_id

                exit_if_no_argument_from_argv1 $argv[1]
                set action $argv[1]
                set --erase argv[1]

                switch $action
                    case recover
                        echo "Recovering network configuration for $network_id ..."
                        # Network recovery logic here
                        echo "Stopping and disabling TAP setup service..."

                        sudo systemctl stop $service_name
                        sudo systemctl disable $service_name
                        sudo rm /etc/systemd/system/$service_name
                        sudo systemctl daemon-reload

                        echo "$service_name stopped, disabled, and removed successfully."
                        exit

                    case '*'
                        echo "❓ Error: Invalid subcommand for 'network id <network_id>'"
                        exit 1
                end

            case check
                echo "Checking network status..."

                echo ""
                echo '❔ All IP addresses of network interfaces:'
                ip -c a

                echo ""
                echo '❔ All network links:'
                ip -c l

                echo ""
                echo '❔ All network routes:'
                ip -c r
                exit

            case list
                echo "❔ Listing all network services created by this script:"
                echo $available_network_ids
                exit

            case '*'
                echo "❓ Error: Invalid action for network command"
                usage; and exit 1
        end

    case '*'
        usage; and exit 1
end


: '
❔ About qemu run Options 📰 TODO:
.qcow2 "QEMU Copy On Write (COW) version
## 인수 입력 안한거로 발생한 오류는, usage 는 사용하지 않도록 하기.

📰 echo "  host <action> <sub_action>"
📰 https://www.spice-space.org/spice-user-manual.html

📰 qemu-system-x86_64 .. video streaming 가속 코드 필요.
📰 vm init - ubuntu server, arm64 칩에 대해서 초기화 코드 추가 필요. STM32F103RB-NUCLEO
    #.. 흠.. 아직까지는 왜 필요한지 모르겠음.. arm 보드에 대해서는.. UART 는 된다는데 두 개.. 이거 해보기? 서버 모드? 클라이언트?
    
    qemu-system-arm \
        -M stm32f103c8t6 \
        -m 64M \
        -nographic \
        -serial mon:stdio \
        -kernel path_to_firmware.elf \
        -S -s

    -kernel: 이는 STM32 개발 환경에서 생성한 펌웨어 바이너리 파일입니다.
    -S -s: QEMU가 시작될 때 실행을 멈추고, gdb 디버깅 서버를 열어 디버깅할 수 있게 합니다.

     일반적인 개발 및 테스트 환경에서는 주로 시리얼 통신(UART)을 사용하므로 USB 리디렉션이 필요하지 않음

     UEFI는 주로 x86 기반 시스템에서 사용하는 부팅 로더이기 때문에 Jetson Nano의 Yocto 이미지를 QEMU에서 실행할 때 OVMF는 필요하지 않습니다.

qemu-system-aarch64 \
    -M virt \
    -m 4096 \
    -cpu cortex-a57 \
    -nographic \
    -kernel path_to_kernel_image \
    -append "console=ttyAMA0 root=/dev/vda" \
    -drive file=path_to_rootfs_image,if=virtio \
    -netdev tap,id=net0,ifname=tap0,script=no,downscript=no \
    -device virtio-net-pci,netdev=net0

📰 Check Hash value when iso image download and use (init)

📰 server 실행 시에는 spice 프로토콜이 아니라 .. ssh 로 접속해야 함.
    cloud-init이 포함된 Ubuntu 서버 이미지는 기본적으로 SSH 서비스가 활성화된 상태로 시작됩니다.
    client run 을 하면 접속 주소 
    그러니까 즉 명령어가 amd/arm.. 아키텍처에 따라 달라지고, client run 도 vm_id 가 서버인지 아닌지에 따라 달라지고,
    qemu server 실행하는 것도 데스크탑인가에 따라 달라지고

📰 device 직접 넘겨주기?
set usb_info (lsusb | grep -i CAMERA)
if test -z $usb_info
    echo "Not found valid Camera device"
    exit 1
end

set bus_id (echo $usb_info | awk \'{print $2}\')
set device_id (echo $usb_info | awk \'{print $4}\' | tr --delete \':\')

set vendor_id (echo $usb_info | awk \'{print $6}\' | cut --delimiter \':\' --fields=1)
set product_id (echo $usb_info | awk \'{print $6}\' | cut --delimiter \':\' --fields=2)
# echo "Bus ID: $bus_id"
# echo "Device ID: $device_id"
# echo "Vendor ID: $vendor_id"
# echo "Product ID: $product_id"


user-data.yml 과 meta.yaml 은 다르게 해야 함.
공용 network-config.yml 에 대한 대처..

'


# Ticketing is a simple authentication system which enables you to set simple tickets to a VM. Client has to authenticate before the connection can be established. See the Spice option password in the following examples.
#📰 wbfw109v2@iot4-computer ~/r/synergy-hub (main)> fish temp.fish
# qemu-system-x86_64: SPICE GL support is local-only for now and incompatible with -spice port/tls-port
####### 
# TODO: Spice server supports the QXL VDI interface. QXL, SFALIC, GLZ, Lempel-Ziv (LZ) algorithm, Both Quic and LZ are local algorithms...
## client$ remote-viewer spice://myhost:3001
# remote-viewer spice+unix:///run/user/1000/spice.sock
# https://www.spice-space.org/api/spice-gtk/SpiceUsbDeviceManager.html#SpiceUsbDeviceManager--auto-connect-filter

## 🤬 manually run: click 'music' icon (media) on the top-left of QEMU from remote viewer; 
#   'Select USB devices for redirection'
# ❓ cloud-localds; cloud local data source
# ❓ https://en.wikipedia.org/wiki/USB#Device_classes
# ❓ VGA(Video Graphics Array)
# ❓ QXL(Quick eXecuting Layer)
# ❓ UHCI (Universal Host Controller Interface): USB 1.1 규격의 컨트롤러입니다
# ❓ EHCI (Enhanced Host Controller Interface): USB 2.0 규격의 컨트롤러입니다
# ❓ ich9 (Intel I/O Controller Hub 9): Intel에서 제공하는 하드웨어 칩셋 중 하나입니다.
# sudo killall qemu-system-x86_64
# -display spice-app
### qemu-system-x86_64 -device help | grep virtio
# https://www.spice-space.org/spice-user-manual.html#spice-protocol
: '
### `-enable-kvm`
# Enables KVM (Kernel-based Virtual Machine) for hardware acceleration.
# This allows the VM to use the host CPU more efficiently, improving performance.

### `-smp 1`
# Specifies the number of CPU cores allocated to the VM. Here, only 1 core is assigned.
# 🪱 SMP: Symmetric Multiprocessing, meaning the virtual machine can use multiple CPU cores or threads in parallel if assigned.

### `-m 2048`
# Allocates 2048 MB (2 GB) of RAM to the VM for better performance.
# 🪱 The `-m` stands for "memory," specifying the amount of RAM assigned to the virtual machine.

### `-machine q35`
# Emulates a modern Intel platform with PCIe support using the Q35 chipset.

### `-cpu host`
# Passes the host CPU\'s features directly to the VM to ensure compatibility and performance.

### `-netdev tap,id=net0,ifname=tap0,script=no,downscript=no`
# Configures a TAP network interface.
# `script=no`: Disables automatic setup scripts.
# `downscript=no`: Prevents teardown scripts on shutdown.

### `-device virtio-net-pci,netdev=net0,mac=52:54:00:12:34:56`
# Adds a Virtio-based network device with a specific MAC address for performance.
# 🪱 Virtio: A virtualization interface designed for efficient I/O, reducing overhead in virtual machines.

### `-global ICH9-LPC.disable_s3=1`
# Disables S3 suspend-to-RAM state. ICH9-LPC provides legacy device support.
# 🪱 ICH9: Intel I/O Controller Hub 9; LPC: Low Pin Count. The ICH9-LPC interface supports legacy I/O devices like serial ports and PS/2 keyboards.

### `-drive file=OVMF_CODE_4M.secboot.fd,if=pflash,format=raw,unit=0,readonly=on`
# Loads UEFI firmware from a persistent flash storage.
# 🪱 OVMF: Open Virtual Machine Firmware, a project providing UEFI firmware for virtual machines. It enables UEFI boot and configuration in virtual environments.

### `-drive file=OVMF_VARS_4M.ms.fd,if=pflash,format=raw,unit=1`
# Provides writable storage for UEFI variables (e.g., NVRAM).

### `-cdrom cloud-init.iso`
# Mounts the cloud-init ISO to automate VM initialization (e.g., user setup).

### `-boot d`
# Sets the VM to boot from the CD-ROM first.

### `-drive file=ubuntu-vm.qcow2,if=none,id=disk0,format=qcow2,cache=writeback`
# Attaches the QCOW2 disk image with write-back caching for performance.
# 🪱 QCOW2: QEMU Copy-On-Write, a disk image format supporting snapshots and space-efficient storage.

### `-device virtio-blk-pci,drive=disk0,bootindex=1`
# Adds a Virtio block device with primary boot priority.
# 🪱 A Virtio block device allows fast and efficient I/O by reducing the virtualization overhead on the block device.

### `-serial mon:stdio`
# Redirects the QEMU monitor to the terminal\'s standard I/O.
# 🪱 mon:stdio: The monitor interface allows controlling the VM from the terminal for tasks like pausing or rebooting the machine.

### `-device qemu-xhci,id=xhci`
# Adds a USB 3.0 controller with backward compatibility for USB 2.0 and 1.x.
# ⚓ Extensible Host Controller Interface (xhci) ; https://en.wikipedia.org/wiki/Extensible_Host_Controller_Interface

### `-device usb-host,bus=xhci.0,hostbus=$bus_id,hostaddr=$device_id`
# Passes the host\'s USB device to the VM via the xHCI controller.

'

: '🧪 Test Command
# Test Host file initialization

# Test VM initialization
fish $qcnet vm init vm_test_id -o ubuntu -v 22 -t desktop -a amd64 --disk-size 7
fish $qcnet vm init vm_test_id -o ubuntu -v 24 -t server -a amd64 --disk-size 7

# Test VM server cloud-init setup initialization
fish $qcnet vm id vm_test_id -r server set cloud-init init

# Test VM server clo    ud-init build
fish $qcnet vm id vm_test_id -r server set cloud-init build

# Test VM id list
fish $qcnet vm list



# Test network status check
fish $qcnet network check



# Test VM server start with network TAP name specified
fish $qcnet vm id vm_test_id -r server run -n my_net

# Test VM server stop
fish $qcnet vm id vm_test_id -r server stop

# Test VM server cloud-init run
fish $qcnet vm id vm_test_id -r server run -n yocto_net

# Test VM server cloud-init stop
fish $qcnet vm id vm_test_id -r server stop

# Test VM client start
fish $qcnet vm id vm_test_id -r client run

# Test VM client stop
fish $qcnet vm id vm_test_id -r client stop

# Test network initialization
fish $qcnet network init

# Test network recovery
fish $qcnet network id my_net recover

# Test network service listing
fish $qcnet network list


network init 

'
