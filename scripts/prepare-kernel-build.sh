#!/usr/bin/env bash
set -e

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

# Upgrade all installed dependencies to latest as well as the distro.
echo "> Checking for updates..."
sudo apt update && sudo apt dist-upgrade -y

# Install dependencies for building.
echo "> Install required dependencies to build kernel..."
sudo apt install -y build-essential flex bison dwarves libssl-dev libelf-dev

# Do some cleanup.
echo "> Running some cleanup..."
sudo apt autoremove -y && sudo apt clean -y

# Copying the defualt `kconfig` to `.config`.
echo "> Copying default WSL kconfig to '.config' file..."
cp Microsoft/config-wsl .config
