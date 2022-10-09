#!/usr/bin/env bash
set -e

if [ ! "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
  echo "You must run this script within a git repository."
  exit 1
fi

if [ ! -d "WSL2-Linux-Kernel" ]; then
  echo "This script is meant to be run from the project root. Make sure 'WSL2-Linux-Kernel' folder is visible to current PWD."
  exit 1
fi

pushd WSL2-Linux-Kernel/

# Export required kconfig settings for building.
cat <<EOF >.config-fragment
CONFIG_BT=y
CONFIG_BT_BREDR=y
CONFIG_BT_LE=y
CONFIG_BT_DEBUGFS=y
CONFIG_BT_INTEL=y
CONFIG_BT_BCM=y
CONFIG_BT_RTL=y
CONFIG_BT_HCIBTUSB=y
CONFIG_BT_HCIBTUSB_BCM=y
CONFIG_BT_HCIBTUSB_RTL=y
CONFIG_BT_HCIUART=y
CONFIG_PREVENT_FIRMWARE_BUILD=n
CONFIG_EXTRA_FIRMWARE="rtl_bt/rtl8761bu_fw.bin"
CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware"
EOF

# Copy the defualt `kconfig` to `.config`.
echo "> Copying current kconfig to '.config' file..."
cp /proc/config.gz config.gz && gunzip config.gz
mv config .config

echo "> Merging '.config-fragment' into current '.config'..."
./scripts/kconfig/merge_config.sh .config .config-fragment

# Run the build.
echo "> Running the build..."
N_CORES=$(getconf _NPROCESSORS_ONLN)
make -j $N_CORES && make modules_install -j $N_CORES && make install -j $N_CORES

# Copy the built kernel to `kernel-dist` folder in project root.
echo "> Copying the resulting kernel image..."
cp arch/x86/boot/bzImage ../kernel-dist/nxzr-bzImage

popd
