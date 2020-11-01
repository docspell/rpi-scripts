#!/usr/bin/env nix-shell
#! nix-shell -p parted -i bash
set -e

source $(dirname $(realpath $0))/../config/global

if [ -z "$1" ]; then
   echo "Need a target device"
   exit 1
fi

echo "++++++++++++++++++++++++++++++++"
echo "           WARNING"
echo "++++++++++++++++++++++++++++++++"
echo
echo "Everything on $1 will be erased!"
echo "Press Ctrl-C to quit now."
echo "Press Enter/Return to proceed."
read

echo "Creating a single partition … "
sudo parted "$1" -- mklabel gpt
sudo parted "$1" -- mkpart primary ext4 0% 100%

echo "Formatting the disk …"
sudo mkfs -V -L "$disk_label" -t ext4 "${1}1"
