#!/bin/bash
set -e

echo "Installing GNOME Idle Monitor..."

# Copy the Python script to /usr/local/bin and make it executable
sudo cp -f scripts/gnome_idle_monitor.py /usr/local/bin/gnome_idle_monitor
sudo chmod +x /usr/local/bin/gnome_idle_monitor

# Copy the configuration file to the user's config directory
mkdir -p $HOME/.config/gnome_idle_monitor
cp -f config/gnome_idle_monitor.conf $HOME/.config/gnome_idle_monitor/gnome_idle_monitor.conf

# Optionally, copy the user systemd service file to its target directory
mkdir -p $HOME/.config/systemd/user
cp -f systemd/gnome_idle_monitor.service $HOME/.config/systemd/user/gnome_idle_monitor.service

systemctl --user daemon-reload
echo "Installation complete!"
echo "Enable service: systemctl --user enable gnome_idle_monitor.service"
echo "Start service: systemctl --user start gnome_idle_monitor.service"
