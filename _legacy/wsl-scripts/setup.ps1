Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

wsl --exec "sudo apt update && sudo apt dist-upgrade -y"
# Note that, in fact, we are not going to use dbus for the operation. However,
# we are just making sure the latest dbus to be installed in case of failure to
# use dbus-broker.
wsl --exec "sudo apt install linux-tools-virtual hwdata bluez dbus dbus-broker"
wsl --exec "sudo apt autoremove -y && sudo apt clean -y"
wsl --exec "sudo update-alternatives --install /usr/local/bin/usbip usbip `ls /usr/lib/linux-tools/*/usbip | tail -n1` 20"
