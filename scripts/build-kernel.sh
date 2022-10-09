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

if [ ! -f ".config" ]; then
  echo "'.config' file does not exist. Did you run the 'prepare' script?"
  exit 1
fi

pushd WSL2-Linux-Kernel/

# Run the build.
N_CORES=$(getconf _NPROCESSORS_ONLN)
make -j $N_CORES && make modules_install -j $N_CORES && make install -j $N_CORES

# Copy the built kernel to `kernel-dist` folder in project root.
cp arch/x86/boot/bzImage ../kernel-dist/nxzr-bzImage

popd
