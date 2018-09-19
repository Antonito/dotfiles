#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v
# Keep-alive: update existing `sudo` time stamp until `setup.sh` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "[*] Tweaking Operating System..."
./tweak_os.sh

echo "[*] Installing and configuring sofware..."
./install_apps.sh

echo "[*] Rebooting computer ... (press enter)"

read reboot_opt
osascript -e 'tell app "System Events" to restart'
killall "Terminal"