#!/usr/bin/env bash

set -xe

# Variables
KANATA_PATH="$(which kanata)"
KANATA_CFG_PATH="$HOME/.config/kanata/config.kbd"
SUDOERS_FILE="/etc/sudoers.d/kanata"
SYSTEM_FILE="/lib/systemd/system/kanata.service"

# Create a sudoers file entry for kanata
echo "$(whoami) ALL=(ALL) NOPASSWD: $KANATA_PATH" | sudo tee "$SUDOERS_FILE" > /dev/null

cat <<EOF | sudo tee "$SYSTEM_FILE" > /dev/null
[Unit]
Description=Kanata Keyboard Remapper
Documentation=https://github.com/jtroo/kanata

[Service]
Type=simple
ExecStart=$KANATA_PATH -c $KANATA_CFG_PATH -n
Restart=never

[Install]
WantedBy=default.target
EOF

sudo systemctl start kanata
sudo systemctl enable kanata
