# nxzr-helper

> A collection of tools and resources that helps nxzr project to work

## Prerequisite

Assuming you are in WSL + Ubuntu environment:

```shell
./scripts/upgrade-ubuntu-latest.sh
```

## WSL2-Linux-Kernel with Bluetooth support

### Preparing

```shell
./scripts/prepare-kernel-build && ./scripts/prepare-firmware
```

### Building the Kernel

```shell
./scripts/build-kernel.sh
```
