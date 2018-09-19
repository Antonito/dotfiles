#!/usr/bin/env bash

echo "[*] Tweaking Operating System..."
./tweak_os.sh

echo "[*] Installing and configuring sofware..."
./install_apps.sh

echo "[*] Rebooting computer ... (press enter)"

read reboot_opt
sudo shutdown -r now