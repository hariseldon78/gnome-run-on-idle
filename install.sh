#!/bin/bash
set -e

echo "Installing GNOME Idle Monitor..."

# Copy the Python script to /usr/local/bin and make it executable
cp -f scripts/gnome_idle_monitor.py /usr/local/bin/gnome_idle_monitor
chmod +x /usr/local/bin/gnome_idle_monitor

# Copy the configuration file to /etc
cp -f config/gnome_idle_monitor.conf /etc/gnome_idle_monitor.conf

# Optionally, copy the systemd service file to its target directory
cp -f systemd/gnome_idle_monitor.service /etc/systemd/system/gnome_idle_monitor.service

sudo systemctl daemon-reload
echo "Installation complete!"
echo "Enable service: sudo systemctl enable gnome_idle_monitor.service"
echo "Start service: sudo systemctl start gnome_idle_monitor.service"
