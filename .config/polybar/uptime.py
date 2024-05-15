#!/usr/bin/env python3
import subprocess

max_char = 52

uptime = str(subprocess.run(["uptime -p"], capture_output=True, shell=True).stdout)
uptime = uptime.replace(" days", "d").replace(" hours", "h").replace(" minutes", "m")
uptime = uptime.replace(" day", "d").replace(" hour", "h").replace(" minute", "m")
timeleft = str(
    subprocess.run(
        [
            "upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep 'time to empty'"
        ],
        capture_output=True,
        shell=True,
    ).stdout
).split()

msg = uptime[2:-3]
try:
    msg += ", " + timeleft[4] + "h left"
except:
    msg += ", Charging..."
print(msg)
