#!/usr/bin/env nix-shell
#! nix-shell -p dcfldd -p p7zip -p curl -i bash

source $(dirname $(realpath $0))/../config/global

if [ -z "$1" ]; then
   echo "Need a target device"
   exit 1
fi


if [ ! -e $target/dietpi_image.7z ]; then
    echo "Downloading dietpi image ..."
    curl -L -o $target/dietpi_image.7z $dietpi_image
fi
echo "Extracting dietpi image ..."
7z e -o$target $target/dietpi_image.7z

image=$(ls -1 $target/DietPi*.img)

echo "Flashing $image to device $1 ..."
sudo dcfldd bs=1M if="$image" of="$1"
sudo sync
