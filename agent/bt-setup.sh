#!/usr/bin/env bash
set -e

if [ $EUID -ne 0 ]; then
  echo "This script must be run as root."
  exit 1
fi

# 1. Setup
## Disable history for the moment.
unset HISTFILE
## Go to home directory.
cd ~

# 2. Install or upgrade dependencies
## Set `apk` repository settings
cat <<'EOF' > /etc/apk/repositories
https://dl-cdn.alpinelinux.org/alpine/latest-stable/main
https://dl-cdn.alpinelinux.org/alpine/latest-stable/community
https://dl-cdn.alpinelinux.org/alpine/edge/main
EOF
## Upgrade all installed dependencies to latest as well as the distro.
echo "> Checking for updates..."
apk update && apk upgrade
## Install required packages.
echo "> Installing required dependencies..."
apk add --no-cache openrc linux-tools-usbip hwdata bluez bluez-deprecated dbus libgcc gcompat
## Link `usbip`
ln -sf /usr/sbin/usbip /usr/local/bin/usbip

# 3. Setup configs
## Update WSL config to enable startup services.
cat <<'EOF' > /etc/wsl.conf
[boot]
systemd=false
command="/sbin/openrc default"
EOF
## Set bluetooth enabled flag to system default settings.
mkdir -p /etc/default/
echo "export BLUETOOTH_ENABLED=1" > /etc/default/bluetooth
## Replace `bluetoothd` service run definition.
sed -i 's#\(command="/usr/lib/bluetooth/bluetoothd"\).*#\1\ncommand_args="--noplugin=*"#' /etc/init.d/bluetooth
## Enable the services.
rc-update add dbus
rc-update add bluetooth

# 4. Cleanup
## Remove unrelated files.
echo "> Running some cleanup..."
## Cleanup home folder.
rm -f .ash_history
## Remove logs.
rm -rf /var/log/*
## Purge `apk` related files.
apk cache clean
rm -rf /var/cache/apk/*
## Remove all temporary files.
find /tmp -mindepth 1 -delete
