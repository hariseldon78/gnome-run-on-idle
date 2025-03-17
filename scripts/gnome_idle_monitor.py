#!/usr/bin/env python3
import subprocess
import time
import os
import shlex


def read_config(config_file):
    config = {}
    with open(config_file) as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#"):
                key, val = line.split("=", 1)
                config[key.strip()] = val.strip()
    return config


def get_idle_time():
    # Call dbus-send to get the idle time in milliseconds
    result = subprocess.run(
        ["dbus-send", "--session", "--dest=org.gnome.Mutter.IdleMonitor",
         "/org/gnome/Mutter/IdleMonitor", "org.gnome.Mutter.IdleMonitor.GetIdletime"],
        capture_output=True, text=True
    )
    for line in result.stdout.splitlines():
        if "uint64" in line:
            try:
                return int(line.split("uint64")[-1].strip())
            except Exception:
                return 0
    return 0


def is_on_power(config):
    # Check if system is on AC power via supplied power supply path
    power_supply_path = config.get("POWER_SUPPLY_PATH", "/sys/class/power_supply/ADP1/online")
    if os.path.exists(power_supply_path):
        try:
            with open(power_supply_path) as f:
                return f.read().strip() == "1"
        except Exception:
            pass
    # Fallback: assume on power if not determinable
    return True


def run_command(command):
    print(f"Running command: {command}")
    subprocess.run(shlex.split(command))


def main():
    config_file = "/etc/gnome_idle_monitor.conf"
    config = read_config(config_file)
    battery_idle_time = int(config.get("ON_BATTERY_IDLE_TIME", "300"))
    power_idle_time = int(config.get("ON_POWER_IDLE_TIME", "600"))
    battery_idle_command = config.get("ON_BATTERY_IDLE_COMMAND", "echo 'Suspend then hibernate'")
    power_idle_command = config.get("ON_POWER_IDLE_COMMAND", "echo 'Suspend'")
    poll_interval = 5

    print("Starting GNOME Idle Monitor...")
    while True:
        idle_ms = get_idle_time()
        idle_seconds = idle_ms / 1000
        if is_on_power(config):
            threshold = power_idle_time
            command = power_idle_command
        else:
            threshold = battery_idle_time
            command = battery_idle_command

        if idle_seconds >= threshold:
            run_command(command)

        time.sleep(poll_interval)

if __name__ == "__main__":
    main()
