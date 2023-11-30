#!/bin/bash

# Update package lists
sudo apt update -y

# Upgrade installed packages
sudo apt upgrade -y

# Perform a distribution upgrade
sudo apt dist-upgrade -y

# Remove unused packages
sudo apt autoremove -y

# Clean the package cache
sudo apt clean -y

# Set the timezone to Asia/Tehran
sudo timedatectl set-timezone Asia/Tehran

# Enable network time synchronization
timedatectl set-ntp true

# Restart systemd-timesyncd service
systemctl restart systemd-timesyncd

# Restart systemd-timedated service
sudo systemctl restart systemd-timedated

# Create and configure a swap file
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Add the swap file to /etc/fstab
sudo sh -c 'echo "/swapfile swap swap defaults 0 0" >> /etc/fstab'

# Configure vm.swappiness
sudo sysctl vm.swappiness=10
sudo sh -c 'echo "vm.swappiness=10" >> /etc/sysctl.conf'

# Install additional packages
sudo apt install -y policycoreutils selinux-utils selinux-basics

# Check SELINUX value in /etc/selinux/config
selinux_config="/etc/selinux/config"
selinux_value=$(grep -Po '(?<=SELINUX=)[a-zA-Z]+' "$selinux_config")

echo "Current SELINUX value: $selinux_value"

# Change SELINUX value to disabled
sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/' "$selinux_config"
echo "SELINUX value updated to disabled"

# Modify /etc/security/limits.conf
sudo sh -c 'echo "* hard nofile 64000" >> /etc/security/limits.conf'
sudo sh -c 'echo "* soft nofile 64000" >> /etc/security/limits.conf'
sudo sh -c 'echo "root hard nofile 64000" >> /etc/security/limits.conf'
sudo sh -c 'echo "root soft nofile 64000" >> /etc/security/limits.conf'

# Append configurations to /etc/sysctl.conf
sudo sh -c 'cat <<EOT >> /etc/sysctl.conf
# max open files
fs.file-max = 51200
# max read buffer
net.core.rmem_max = 67108864
# max write buffer
net.core.wmem_max = 67108864
# default read buffer
net.core.rmem_default = 65536
# default write buffer
net.core.wmem_default = 65536
# max processor input queue
net.core.netdev_max_backlog = 4096
# max backlog
net.core.somaxconn = 4096
# resist SYN flood attacks
net.ipv4.tcp_syncookies = 1
# reuse timewait sockets when safe
net.ipv4.tcp_tw_reuse = 1
# turn off fast timewait sockets recycling
net.ipv4.tcp_tw_recycle = 0
# short FIN timeout
net.ipv4.tcp_fin_timeout = 30
# short keepalive time
net.ipv4.tcp_keepalive_time = 1200
# outbound port range
net.ipv4.ip_local_port_range = 10000 65000
# max SYN backlog
net.ipv4.tcp_max_syn_backlog = 4096
# max timewait sockets held by system simultaneously
net.ipv4.tcp_max_tw_buckets = 5000
# turn on TCP Fast Open on both client and server side
net.ipv4.tcp_fastopen = 3
# TCP receive buffer
net.ipv4.tcp_rmem = 4096 87380 67108864
# TCP write buffer
net.ipv4.tcp_wmem = 4096 65536 67108864
# turn on path MTU discovery
net.ipv4.tcp_mtu_probing = 1
# for high-latency network
net.ipv4.tcp_congestion_control = hybla
# for low-latency network, use cubic instead
net.ipv4.tcp_congestion_control = cubic
sysctl --system
sysctl -p

net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
EOT'

# Reboot the server
sudo reboot
