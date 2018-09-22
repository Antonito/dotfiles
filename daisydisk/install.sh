#!/usr/bin/env bash

# Install license only if it's found

if [ -f 'License.DaisyDisk' ]; then
    cp 'License.DaisyDisk' "$HOME/Library/Application Support/DaisyDisk/License.DaisyDisk"
fi