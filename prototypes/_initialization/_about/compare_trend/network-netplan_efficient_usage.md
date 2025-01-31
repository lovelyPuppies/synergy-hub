# Netplan Usage and Service Management

📅 Written at 2024-11-18 17:02:13

## Why Netplan and its 🪱 Renderer Choices?

In Ubuntu, Netplan has become the default tool for managing network configurations. It provides a unified YAML-based configuration structure that can hand off the actual management to either `NetworkManager` or `systemd-networkd`, depending on the environment.

From the quoted Reddit statement:

> "Going forward in Ubuntu, you'll want to continue to use netplan, and get familiar with the network scripts it renders for you, based on your individual renderer needs (eg: desktop using NetworkManager vs. server using networkd)."

This reflects the design philosophy in Ubuntu for adapting the network management tool to the needs of the environment.

### Key Takeaways:

1. **Desktop Environment (GUI-Centric)**:
   - Uses **`NetworkManager`** as the renderer.
   - Suitable for environments requiring Wi-Fi, VPN, and dynamic network configurations.
2. **Server Environment (CLI-Centric)**:
   - Uses **`systemd-networkd`** as the renderer.
   - Ideal for static IP configurations, VLANs, and other fixed network setups.

---

## NetworkManager vs. systemd-networkd

### `NetworkManager` (⭕ for Desktop)

- **Features**:

  - GUI support for user-friendly management.
  - Handles Wi-Fi, VPN, mobile network (3G/4G) configurations.
  - Dynamic configurations with DHCP, DNS, and Proxy settings.
  - CLI support via `nmcli`.

- **Why for Desktop**:
  - Designed for environments where networks frequently change, such as laptops and mobile devices.
  - Provides a seamless experience for managing complex network needs.

### `systemd-networkd` (⭕ for Server)

- **Features**:

  - Lightweight and efficient for server environments.
  - Manages static IP, VLAN, bridge, and tunneling configurations.
  - CLI management without GUI dependencies.

- **Why for Server**:
  - Ideal for stable, static network environments like servers and IoT devices.
  - Reduces resource overhead compared to NetworkManager.

---

## Can Both Services Be Active Simultaneously?

Yes, both `systemd-networkd` and `NetworkManager` can be active at the same time. However, this is not recommended as it might lead to conflicts, especially if both try to manage the same network interfaces.

### Behavior:

- Netplan chooses the renderer based on the YAML configuration (`renderer: networkd` or `renderer: NetworkManager`).
- The renderer specified in Netplan will manage the interfaces, while the other service will remain idle.

### Risks of Both Active:

- Potential conflicts if both services attempt to manage the same network interface (e.g., `eth0`, `wlan0`).
- Unexpected behavior due to overlapping configurations.

---

## Default Renderer in Ubuntu

1. **Desktop Environment**:

   - Default: **`NetworkManager`**.
   - The YAML configuration will include `renderer: NetworkManager`.

2. **Server Environment**:
   - Default: **`systemd-networkd`**.
   - The YAML configuration will include `renderer: networkd`.

---

## Checking and Managing Services

### 1. Check Active Services:

```bash
sudo systemctl is-active systemd-networkd
sudo systemctl is-active NetworkManager
```

### 2. Check Netplan Configuration:

```bash
cat /etc/netplan/*.yaml
```

### 3. Interface Control Status:

- **Interfaces managed by `systemd-networkd`**:
  ```bash
  networkctl
  ```
- **Interfaces managed by `NetworkManager`**:
  ```bash
  nmcli device status
  ```

### 4. Adjust Services:

- To use **`NetworkManager`**, disable `systemd-networkd`:

  ```bash
  sudo systemctl stop systemd-networkd
  sudo systemctl disable systemd-networkd
  sudo systemctl start NetworkManager
  sudo systemctl enable NetworkManager
  ```

- To use **`systemd-networkd`**, disable `NetworkManager`:
  ```bash
  sudo systemctl stop NetworkManager
  sudo systemctl disable NetworkManager
  sudo systemctl start systemd-networkd
  sudo systemctl enable systemd-networkd
  ```

---

## 📍🧪 Testing with `ping` and `ssh`

### **Comparison Table**

| Command | Input Format             | Example                  | Key Conditions                          |
| ------- | ------------------------ | ------------------------ | --------------------------------------- |
| `ping`  | `<hostname>`             | `ping raspberrypi`       | Defined in DNS or `/etc/hosts`          |
|         | `<hostname>.local`       | `ping raspberrypi.local` | Requires mDNS service (`avahi-daemon`)  |
|         | `<IP address>`           | `ping 192.168.1.100`     | Direct IP address connection            |
| `ssh`   | `<hostname>`             | `ssh raspberrypi`        | Defined in DNS or `/etc/hosts`          |
|         | `<hostname>.local`       | `ssh raspberrypi.local`  | Requires mDNS service                   |
|         | `<username@IP address>`  | `ssh pi@192.168.1.100`   | Direct IP address connection            |
|         | Alias in `~/.ssh/config` | `ssh rpi-alias`          | Alias defined in SSH configuration file |

## Conclusion

- **For Desktop Environments**: Use `NetworkManager` for dynamic configurations like Wi-Fi and VPN.
- **For Server Environments**: Use `systemd-networkd` for static and lightweight configurations.
- Always ensure that only one network management service actively controls the interfaces to avoid conflicts.

Netplan simplifies the choice between these tools, allowing you to configure your network using a single YAML file and automatically rendering configurations for the selected renderer.

## Reference

- [Few Questions about NetworkManager vs systemd-networkd on both RedHat and ubuntu](https://www.reddit.com/r/linuxadmin/comments/klhcpt/few_questions_about_networkmanager_vs/)
- [Netplan Documentation](https://netplan.io/)
- [Ubuntu Networking](https://ubuntu.com/server/docs/network-configuration)
