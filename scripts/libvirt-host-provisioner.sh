#!/bin/bash

set -euxo pipefail

# Silence is bliss.
touch "/root/.hushlogin"

# Update the package index.
apt update

# Disable the systemd-resolved stub listener and install dnsmasq.
# This is required to manage libvirt networks.
cat <<EOF | tee -a /etc/systemd/resolved.conf
DNSStubListener=no
EOF
systemctl restart systemd-resolved


# Install libvirt and guest utilities.
apt --yes install --no-install-recommends libguestfs-tools libvirt-daemon-system qemu-system

# Wait for the libvirtd socket to be present.
until [[ -S /var/run/libvirt/libvirt-sock ]];
do
  sleep 1
done

# Work around https://github.com/dmacvicar/terraform-provider-libvirt/issues/97.
cat <<EOF | tee -a /etc/libvirt/qemu.conf
security_driver = "none"
EOF
systemctl restart libvirtd

## install the br0 and configure the br0 so the VMs can have the public IP address. we can consider to move all of these to cloud init later
apt install --yes bridge-utils
brctl addbr br0
physical_nics_config=$(awk '/^auto [a-zA-Z0-9]+/ {if (!/^auto bond/) {p=1} else {p=0}} p' /etc/network/interfaces)
config_lines=$(sed -n '/^auto bond0/,/^auto/ { /^auto/! { p } }' /etc/network/interfaces)
ip_address=$(echo "$config_lines" | awk '/address/ {print}')
netmask=$(echo "$config_lines" | awk '/netmask/ {print}')
gateway=$(echo "$config_lines" | awk '/gateway/ {print}')
bond_physical_nics=$(echo "$config_lines" | awk '/bond-slaves/ {print}')

cp /etc/network/interfaces /etc/network/interfaces.bak


cat <<EOL > /etc/network/interfaces
$physical_nics_config

auto bond0
iface bond0 inet manual
    bond-downdelay 200
    bond-miimon 100
    bond-mode 4
    bond-updelay 200
    bond-xmit_hash_policy layer3+4
$bond_physical_nics

auto br0
iface br0 inet static
$ip_address
$netmask
$gateway
    bridge_ports bond0
    bridge_stp off
EOL

systemctl restart networking


# fdisk extra disk so we can increase the swap size because I use 64G memory machine to deploy OCP which is not enough. To save the cost to deploy the OCP, I increased the swap size so it can have enough memory to hold the VMs

all_disks=$(lsblk -p -o NAME,TYPE --raw | awk '$2 == "disk" {print $1}')
partitions=$(lsblk -p -o NAME,TYPE --raw | awk '$2 == "part" {print $1}' | head -1)

for disk in $all_disks; do
  if ! echo "$partitions" | grep -q "$disk"; then
    echo "Unmounted Disk: $disk"
    unmounted_disk=$disk
    break
  fi
done
echo -e "n\np\n1\n\n+100G\nn\np\n2\n\n\nw" | fdisk "$unmounted_disk"

mkswap "${unmounted_disk}1"
mkfs.ext4 "${unmounted_disk}2"
swapon "${unmounted_disk}1"

echo "${unmounted_disk}1   none   swap   sw   0   0" |  tee -a /etc/fstab
