#!/usr/bin/env bash
set -e

if [[ ! -f ".config" ]]; then
    echo "'.config' file does not exist. Did you run the prepare script?"
    exit 1
fi

make -j 8 && make modules_install -j 8 && make install -j 8
