#!/usr/bin/env fish
# Written at 📅 2024-10-28 13:48:11
function list_eth_interfaces
    : '    
    🔧 Usage
        list_eth_interfaces
    🛍️ e.g.
        # Load modules
        set -x FISH_MODULES_DIR prototypes/_initialization/ubuntu/fish_modules
        source $FISH_MODULES_DIR/network_utils.fish

        set physical_interfaces (list_eth_interfaces)

        echo "Your default ethernet physic interface is '$physical_interfaces'!"

    This function lists all physical network interfaces by excluding virtual ones.
    It uses `find` to traverse the /sys/class/net directory with specific conditions.

    🚣 Each line (item) applies the result of the OR condition (`-o`).
    If an interface is a symbolic link pointing to "*virtual*", it is pruned (skipped from further search).
    Otherwise, the name of the interface is printed using `-printf`.

    🚦 Explanation of `-lname`:
    The `-lname` option in `find` matches symbolic links whose target path matches a specific pattern.
    In this case, it matches links whose target paths contain "virtual". 
    If the link points to such a target, it indicates a virtual interface (e.g., `tailscale0` or `lo`).
    
    🚦 Note on `-prune` and `-o`:
    - The `-prune` option **stops the search** for any matching items, preventing further traversal into those paths.
    - **However, `-prune` alone does not control whether the matched items are displayed.**
    - To exclude the pruned items from being printed, the **`-o` (OR) condition must be used**.
    - In this function, the `-o` ensures that only non-virtual interfaces are printed.

    References
    - https://unix.stackexchange.com/a/677988

    # 📰 TODO:.. in raspberry pi, ... not one..
        pi@pi19:~ $ find /sys/class/net -mindepth 1 -maxdepth 1 \
            -lname \'*virtual*\' -prune -o -printf \'%f\n\'
            wlan0
            eth0
    '

    # Find and print all non-virtual network interfaces
    find /sys/class/net -mindepth 1 -maxdepth 1 \
        -lname '*virtual*' -prune -o -printf '%f\n' | grep '^e'
end

function list_wlan_interfaces
    find /sys/class/net -mindepth 1 -maxdepth 1 \
        -lname '*virtual*' -prune -o -printf '%f\n' | grep '^w'
end

