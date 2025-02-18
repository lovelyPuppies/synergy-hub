### Glossary

- [Oroca](https://github.com/oroca)
  Oroca is a project group established by a Korean developer

- ROS_HOSTNAME 🆚 ROS_NAMESPACE

  | **Property**          | **ROS_HOSTNAME**                                | **ROS_NAMESPACE**                                                                   |
  | --------------------- | ----------------------------------------------- | ----------------------------------------------------------------------------------- |
  | **Purpose**           | Specifies the network address of the node       | Groups node names under a namespace to avoid conflicts and enable modularity        |
  | **Network Related**   | Directly related to network communication       | Unrelated to network, used for logical grouping of topics, services, and parameters |
  | **Unique Identifier** | Ensures unique network address                  | Ensures unique naming for topics, services, and parameters within a namespace       |
  | **Typical Values**    | IP address or container name                    | `/robot1`, `/robot2`, dynamically set for each robot or instance                    |
  | **Use Case**          | For identifying a node in network communication | For avoiding name conflicts and organizing nodes in multi-robot or modular systems  |
  | **Dynamic Usage**     | Typically static, tied to the node's network    | Often dynamically set per robot or instance for flexible usage                      |
  | **Example**           | `ROS_HOSTNAME=192.168.1.101`                    | `ROS_NAMESPACE=/robot1`                                                             |

### 🚧 Prerequsite

- Run script in Host

  ```
  fish prototypes/_initialization/ubuntu/howto/general/setup_xauthority.fish
  fish prototypes/_initialization/ubuntu/howto/general/setup_x11_docker.fish
  ```

- **Edit `.env` File**  
  Update the following values in the `.env` file to configure your ROS DevContainer:
  ```env
  ROS_MASTER_URI=http://<host_ip>:11311
  ROS_HOSTNAME=<host_ip_or_container_name>
  ```
  - Replace `<host_ip>` with the IP address of your host machine.
  - If needed, replace `<host_ip_or_container_name>` with your container name for internal communication.

---

### 1️⃣ Turtlebot 3 installation in Host

#### Download and unzip image file

```bash
#!/usr/bin/env fish

### 🤚 User interaction: Download TurtleBot3 SBC Image ; https://emanual.robotis.com/docs/en/platform/turtlebot3/sbc_setup/#download-turtlebot3-sbc-image

## 🌴 If Raspberry pi 3B+ ROS Noetic image
# wget -O ~/Downloads/turtlebot3_img.zip https://uc78af44b8f08ee5be6fed0f873e.dl.dropboxusercontent.com/cd/0/get/Chy-y3JWxMyNUXdH2PPbkcRQrQIeHB7Hf5J4gFNBApzPGDH96adDhuN-RmENmtUagr-la0UdyTpCt4WpwUr_BWn56NKQ2aw70DQLZWWJVH19t4rSbVjckNSexw2tAEDOrEPhKz0Xd7vBBQGSuHsS54Sm/file?dl=1

## 🌴 If Raspberry Pi 4B (2GB or 4GB) ROS Noetic image
# wget -O ~/Downloads/turtlebot3_img.zip https://uc5279c49ae348c5b5b7d3ad14c6.dl.dropboxusercontent.com/cd/0/get/ChwjnpCLCreYAXEtP32ne_Ntfy-birwEgKDogLxEvKWe99nmgmDy6WA7NWe_VsPuuzlKC89BqTUFIQuMS-CL8bBTu42xsA2CCBLbY51bX0SGFQPCJbFmBpT2GaqSUGNgcBAgUiJhFaonSjq_I64pXZ8N/file?dl=1

###
unzip ~/Downloads/turtlebot3_img.zip -d turtlebot3_img

```

#### 🤚 User interaction: Mount Card reader device to Host PC

#### Write the image file to SD card

```bash
#!/usr/bin/env fish

## Install rpi-imager
sudo apt install -y rpi-imager
rpi-imager
# 🤚 User interaction: ...
```

#### Extend the SD card partitions to provide sufficient space for operations.

```bash
#!/usr/bin/env fish

# Run partition manager (if not KDE environment, install "gparted" and run)
sudo partitionmanager
# 🤚 User interaction: ...
```

#### Modify network settings and Hostname

```bash
#!/usr/bin/env fish

# check mount location of SD Card
lsblk

# 🤚 User interaction: Set the mount parent directory of the SD card
set mount_parent <...>

sudo mv 50-cloud-init.yaml  $mount_parent/etc/netplan/50-cloud-init.yaml
echo bot19 | sudo tee $mount_parent/etc/hostname
```

#### After unmounting, reinsert the SD card into the TurtleBot

### 2️⃣ Turtlebot 3 installation in Turtlebot 3

#### [OpenCR Setup](https://emanual.robotis.com/docs/en/platform/turtlebot3/opencr_setup/#opencr-setup)

- 🤚 User interaction: Connect the OpenCR to the Rasbperry Pi using the micro USB cable

- Update Firmware

  ```bash
  #!/usr/bin/env fish

  # Install required packages on the Raspberry Pi to upload the OpenCR firmware.
  sudo dpkg --add-architecture armhf
  sudo apt-get update && apt-get install -y libc6:armhf
  # Depending on the platform, use either burger or waffle for the OPENCR_MODEL name.
  export OPENCR_PORT=/dev/ttyACM0
  export OPENCR_MODEL=burger_noetic
  rm -rf ./opencr_update.tar.bz2
  # Download the firmware and loader, then extract the file.
  wget https://github.com/ROBOTIS-GIT/OpenCR-Binaries/raw/master/turtlebot3/ROS1/latest/opencr_update.tar.bz2
  tar -xvf opencr_update.tar.bz2
  # Upload firmware to the OpenCR.
  cd ./opencr_update
  ./update.sh $OPENCR_PORT $OPENCR_MODEL.opencr

  # sudo reboot
  ```

- If firmware upload fails, try uploading with the recovery mode. Below sequence activates the recovery mode of OpenCR. Under the recovery mode, the STATUS led of OpenCR will blink periodically.

  - Hold down the PUSH SW2 button.
  - Press the Reset button.
  - Release the Reset button.

![alt text](https://emanual.robotis.com/assets/images/parts/controller/opencr10/bootloader_19.png)

#### SSH Connection test

```bash
#!/usr/bin/env fish

# Login with ⚖️ ID ubuntu and ⚖️ PASSWORD turtlebot ; https://emanual.robotis.com/docs/en/platform/turtlebot3/sbc_setup/#sbc-setup

ssh ubuntu@10.10.14.119

```

- 📝 Note: "10.10.14.119" is the TurtleBot's IP address specified in the fil e [turtlebot3/50-cloud-init.yaml](turtlebot3/50-cloud-init.yaml).
  You may need to change this to match your TurtleBot's network configuration.

#### After unmounting, reinsert the SD card into the TurtleBot

# export ROS_MASTER_URI=http://<Remote_PC_IP>:11311

# export ROS_HOSTNAME=<Remote_PC_IP>

export ROS_MASTER_URI=http://10.10.14.19:11311
export ROS_HOSTNAME=10.10.14.19
export TURTLEBOT3_MODEL=burger

---

in Real Turtlebot 3
export ROS_MASTER_URI=http://10.10.14.19:11311
export ROS_HOSTNAME=10.10.14.119
export TURTLEBOT3_MODEL=burger
