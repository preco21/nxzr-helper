#!/usr/bin/env bash
set -e

if [ $EUID -ne 0 ]; then
  echo "This script must be run as root."
  exit 1
fi

# Upgrade all installed dependencies to latest as well as the distro.
echo "> Checking for updates..."
sudo apt update && sudo apt dist-upgrade -y

# Do some cleanup.
echo "> Running some cleanup..."
sudo apt autoremove -y && sudo apt clean -y

# Make sure the update-manager-core exists.
echo "> Installing update-manager-core..."
sudo apt install update-manager-core

# Finally, run upgrade for the distro.
echo "> Trying to upgrade distro to latest version..."
sudo do-release-upgrade -d

# Reboot is required!
if sudo test -f /var/run/reboot-required; then
  if [[ -n "$IS_WSL" || -n "$WSL_DISTRO_NAME" ]]; then
    echo "A reboot is required to finish installing updates. But it seems you are in WSL environment, which requires manual shutdown. Exit the terminal session, then run 'wsl --shutdown' to reboot WSL manually."
  else
    read -p "A reboot is required to finish installing updates. Press [ENTER] to reboot now, or [CTRL+C] to cancel and reboot later."
    sudo reboot
  fi
else
  echo "A reboot is not required. Exiting..."
fi
