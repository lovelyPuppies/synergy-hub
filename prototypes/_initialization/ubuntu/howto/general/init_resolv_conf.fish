#!/usr/bin/env fish
# 📅 Written at 2025-01-12 19:29:40
function on_interrupt
    echo -e "\nScript interrupted. Exiting..."
    # Kill all child processes in the same process group
    kill -- -$fish_pid
    exit 1
end
trap on_interrupt SIGINT

# List of nameservers to check and add (in the correct order)
: 'In Korea, Performance Comparison of Popular Public DNS Servers 📅 2025-01-12 19:22:20
  %shell> ping -c 10 1.1.1.1 | tail -1
    >> rtt min/avg/max/mdev = 0.393/0.495/0.725/0.083 ms
  %shell> ping -c 10 8.8.8.8 | tail -1
    >> rtt min/avg/max/mdev = 36.039/36.095/36.214/0.050 ms
  %shell> ping -c 10 9.9.9.9 | tail -1
    >> rtt min/avg/max/mdev = 53.691/54.546/58.915/1.630 ms
'

# Explanation message
echo "📝 It will set the order of DNS servers to prioritize based on speed and stability."
echo "   1️⃣  Cloudflare DNS (1.1.1.1) is the fastest in Korea, followed by 2️⃣  Google (8.8.8.8) and 3️⃣  Quad9 (9.9.9.9)"
echo "❓ It seems that 1.1.1.1 is blocked during `sudo apt update` in an organization in Korea 📅 2025-01-12 19:41:14"
echo "  So, this script does not add 1.1.1.1."

# Prompt the user to continue
echo "Press any key to continue..."
read --silent
echo "Continuing with the DNS server configuration.."

sudo -v


# set nameservers "9.9.9.9" "8.8.8.8" "1.1.1.1"
set nameservers "9.9.9.9" "8.8.8.8"

# Backup the original /etc/resolv.conf file before making changes
sudo cp /etc/resolv.conf /etc/resolv.conf.bak

# Loop through each nameserver and check/add it to the file
for nameserver in $nameservers
    # Check if the nameserver already exists in the file
    if not grep -q "nameserver $nameserver" /etc/resolv.conf
        # Add the nameserver just after the first non-comment line
        awk -v ns="nameserver $nameserver" '
                BEGIN { is_added = 0 }
                /^[^#]/ && !is_added { print ns; is_added = 1 }
                { print }
            ' /etc/resolv.conf | sudo tee /etc/resolv.conf >/dev/null
    end
end

echo ""
echo "Nameserver update completed. Current ❔ /etc/resolv.conf:"
cat /etc/resolv.conf
