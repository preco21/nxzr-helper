#!/usr/bin/env bash
set -e

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

sudo mkdir -p /lib/firmware/rtl_bt

pushd /lib/firmware/rtl_bt

# Preparing `RTL8761` firmware from `Realtek-OpenSource` repository.
# - Source: https://github.com/Realtek-OpenSource/android_hardware_realtek/tree/rtk1395/bt/rtkbt/Firmware/BT
sudo wget https://raw.githubusercontent.com/Realtek-OpenSource/android_hardware_realtek/rtk1395/bt/rtkbt/Firmware/BT/rtl8761bt_fw -O rtl8761b_fw.bin
sudo wget https://raw.githubusercontent.com/Realtek-OpenSource/android_hardware_realtek/rtk1395/bt/rtkbt/Firmware/BT/rtl8761bt_config -O rtl8761b_config.bin
sudo cp rtl8761b_fw.bin rtl8761bu_fw.bin
sudo cp rtl8761b_config.bin rtl8761bu_config.bin

popd
