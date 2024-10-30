# Managing Networking: `/etc/network/interfaces` vs. ⭕ `Netplan`

Written at 📅 2024-11-18 15:23:21

This guide compares two approaches for managing network configurations in Ubuntu: the legacy `/etc/network/interfaces` and the newer `Netplan` system.

## 1. Ubuntu Versions and `/etc/network/interfaces`

### Older Versions (Ubuntu 16.04 and Earlier)
- `/etc/network/interfaces` was the primary file for managing network configurations.
- The `dns-nameservers` option was used to define DNS settings and was 💡 relayed to `/etc/resolv.conf` via the `resolvconf` tool.
- **Requirement:** The `resolvconf` package needed to be installed and active for proper DNS configuration.

### Newer Versions (Ubuntu 18.04 and Later)
- Ubuntu introduced `systemd-networkd` or `NetworkManager` as the default network management tools.
- The `dns-nameservers` option is no longer officially supported.
- Instead, newer configuration systems like `Netplan` or NetworkManager configuration files are used.

## 2. ❌ Why `dns-nameservers` May Not Work
### (1) Network Management Tool Change
- Starting with Ubuntu 17.10, `/etc/network/interfaces` is deprecated in favor of `Netplan` and `systemd-networkd`.
- Settings in `/etc/network/interfaces` may be ignored or only partially supported.

### (2) Non-Standardization of `dns-nameservers`
- `dns-nameservers` is a non-standard extension and not supported by all network management tools.
- To make it work, the `resolvconf` package must be installed and functioning correctly.

### (3) Change in `/etc/resolv.conf` Management (🪱 resolv: resolver)
- In newer Ubuntu versions, `systemd-resolved` manages `/etc/resolv.conf` by   default.

  🛍️ e.g.  `/etc/resolv.conf`
  ```plaintext
  nameserver 8.8.8.8
  nameserver 1.1.1.1
  ```

- As a result, DNS settings defined in `/etc/network/interfaces` are often ignored.



## 3. Example: `/etc/network/interfaces` Configuration

### 🛍️ e.g. File: `/etc/network/interfaces`
```plaintext
auto eth0
iface eth0 inet static
    address 192.168.1.100
    netmask 255.255.255.0
    gateway 192.168.1.1
    dns-nameservers 8.8.8.8 8.8.4.4
```

### Applying the Configuration
Restart the networking service to apply changes:
```bash
sudo ifdown eth0 && sudo ifup eth0
```

## 4. Netplan Overview

### Features
| Feature                  | Description                                      |
|--------------------------|--------------------------------------------------|
| **File Location**        | `/etc/netplan/*.yaml`                            |
| **Configuration Format** | YAML                                             |
| **Supported Backends**   | `systemd-networkd`, `NetworkManager`             |
| **Priority**             | Lower-numbered files are applied first           |
| **Application Command**  | `sudo netplan apply`                             |
| **Dynamic or Static IP** | Supports both static and dynamic (DHCP) settings |
| **DNS Configuration**    | Defined using `nameservers` in YAML              |

### How Netplan Processes Files
- Netplan applies files in `/etc/netplan/` based on the alphabetical order of their filenames.
- Lower-numbered or alphabetically earlier files take priority.
- Common naming convention: `01-<name>.yaml`, `50-<name>.yaml`, etc.

### Example: Static IP Configuration
#### 🛍️ e.g. File: `/etc/netplan/01-static.yaml`
```yaml
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    eth0:
      dhcp4: no
      addresses:
        - 192.168.1.100/24
      gateway4: 192.168.1.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
```

#### Applying the Configuration
After creating or modifying a Netplan file, apply the configuration using:
```bash
sudo netplan apply
```

### File Naming Priority
- Netplan processes YAML files in `/etc/netplan/` directory in **alphabetical order**.
- Examples of file names and priorities:
  - `01-first.yaml` (highest priority)
  - `10-second.yaml`
  - `50-third.yaml` (lowest priority)
- If configurations overlap, the settings in files with higher priority (lower number) override the others.

---

## Conclusion
- **Use `/etc/network/interfaces`**: Suitable for legacy systems (Ubuntu 16.04 or earlier) but requires `resolvconf` to function correctly.
- **Use `Netplan`**: Recommended for modern Ubuntu systems (17.10 or later) due to its simplicity and integration with newer tools like `systemd-networkd` or `NetworkManager`.

## Reference
  > [URL](https://www.reddit.com/r/linuxadmin/comments/klhcpt/comment/gh9owqf/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button): Going forward in Ubuntu, you'll want to continue to use netplan, and get familiar with the network scripts it renders for you, based on your individual renderer needs (eg: desktop using NetworkManager vs. server using networkd).
