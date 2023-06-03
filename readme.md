# nxzr-helper

> A collection of tools and resources that helps `NXZR` project to work

This project is intended to be used in conjunction with the original NXZR project, which is currently private.

However, I believe that the scripts used to build its required components do not need to be private. Sharing them could be useful for someone working on Bluetooth-related projects using the WSL.

## Prerequisite

- Windows 10 (`22H2` or later)

You will need to run following `.ps1` scripts using PowerShell that comes with Windows distribution.

## Initial setup (installing WSL + usbipd-win)

Before working with the scripts below, you will need to install the WSL for your system first.

Run following script to install WSL from scratch.

Please note that this script will **also*** install [usbipd-win](https://github.com/dorssel/usbipd-win/) as it will enable the system to use Bluetooth dongle from the WSL environment.

```powershell
.\initial-setup.ps1
```

## Kernel

`NXZR` uses a tailored WSL kernel in order to run Bluetooth stuffs.

This instruction shows how to build the WSL kernel from scratch.

### Prerequisite

Assuming you are in WSL + Ubuntu environment, clone the `nxzr-helper` repository right from the WSL.

```shell
git clone https://github.com/preco21/nxzr-helper.git
```

This repository relies on some git submodules, you will need to make sure all the required submodules to be set before proceeding.

Run submodule setup script:

```shell
./submodule.sh
```

### Step 1. Upgrading Ubuntu to latest

```shell
./kernel/upgrade-ubuntu-latest.sh
```

### Step 2. Building `WSL2-Linux-Kernel` with Bluetooth support

### Step 3. Preparing toolchains

To install all the required dependencies for building Linux kernel, run:

```shell
./kernel/prepare-kernel-build.sh
```

### Step 4. Preparing firmware

By default, this script will download the RTL8761 firmware from Realtek's remote server. However, you may need to customize this step if you intend to use a different Bluetooth device firmware.

### Building the Kernel

Finally, this will trigger the kernel build:

```shell
./kernel/build-kernel.sh
```

## License

`¯\_(ツ)_/¯`
