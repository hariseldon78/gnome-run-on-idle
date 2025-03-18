#!/bin/bash
set -e

echo "Installing GNOME Idle Monitor..."

# Copy the Python script to /usr/local/bin and make it executable
sudo cp scripts/gnome_idle_monitor.py /usr/local/bin/gnome_idle_monitor
sudo chmod +x /usr/local/bin/gnome_idle_monitor

# Copy the configuration file to /etc
sudo cp config/gnome_idle_monitor.conf /etc/gnome_idle_monitor.conf

# Optionally, copy the systemd service file to its target directory
sudo cp systemd/gnome_idle_monitor.service /etc/systemd/system/gnome_idle_monitor.service

echo "Installation complete!"
echo "Reload systemd daemon: sudo systemctl daemon-reload"
echo "Enable service: sudo systemctl enable gnome_idle_monitor.service"
echo "Start service: sudo systemctl start gnome_idle_monitor.service"
