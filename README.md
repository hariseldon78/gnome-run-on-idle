# GNOME Idle Monitor

This application monitors GNOME idle time via DBus and executes a command when the system has been idle for a configured period. It supports separate configurations for battery and AC power modes.

## Installation

1. **Configuration File:**
   - Place the configuration file at: `$HOME/.config/gnome_idle_monitor/gnome_idle_monitor.conf`.
   - Edit the file as needed. Default settings:
     ```
     ON_BATTERY_IDLE_TIME=300
     ON_BATTERY_IDLE_COMMAND=systemctl suspend-then-hibernate
     ON_POWER_IDLE_TIME=600
     ON_POWER_IDLE_COMMAND=systemctl suspend
     POWER_SUPPLY_PATH=/sys/class/power_supply/ADP1/online
     ```

2. **Systemd Service:**
   - The systemd service file is provided at: `systemd/gnome_idle_monitor.service`.
   - Copy it to the user's systemd directory:
     ```bash
     cp systemd/gnome_idle_monitor.service ~/.config/systemd/user/gnome_idle_monitor.service
     ```
   - Reload the user systemd daemon:
     ```bash
     systemctl --user daemon-reload
     ```
   - Enable and start the service:
     ```bash
     systemctl --user enable gnome_idle_monitor.service
     systemctl --user start gnome_idle_monitor.service
     ```

3. **Path Considerations:**
   - The Python script is installed at `/opt/gnome_run_on_idle/scripts/gnome_idle_monitor.py` as per the `ExecStart` in the service file.
   - Make sure the paths in the systemd service file match your installation directories.

## Running the Application

Once the service is started, it will monitor the idle time and execute the commands specified in the configuration file when the idle thresholds are reached.

## Troubleshooting

- Check the service logs with:
  ```bash
  sudo journalctl -u gnome_idle_monitor.service -f
  ```
- Verify that the configuration file is correctly formatted and located in the expected path.
- Ensure that the DBus event `/org/gnome/Mutter/IdleMonitor` is available on your system.

## License

This project is released under the MIT License.
