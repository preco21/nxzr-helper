#!/usr/bin/env bash
set -e

if [ $EUID -ne 0 ]; then
  echo "This script must be run as root."
  exit 1
fi

sudo mkdir -p /lib/firmware/rtl_bt

pushd /lib/firmware/rtl_bt

# Prepare `RTL8761` firmware from `Realtek-OpenSource` repository.
# - Source: https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/rtl_bt/
sudo wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/rtl_bt/rtl8761bu_fw.bin -O rtl8761bu_fw.bin
sudo wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/rtl_bt/rtl8761bu_config.bin -O rtl8761bu_config.bin

popd
