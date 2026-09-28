---
layout: post
title:  "Headless Bluetooth Audio Setup over SSH (PipeWire / WirePlumber / BlueZ)"
date:   2026-09-28 08:38:00 +0800
categories: Util
tags:
- manjaro
- Bluetooth
- PipeWire
- WirePlumber
- BlueZ
- A2DP
---


This guide addresses the common `br-connection-unknown` error and missing PulseAudio/PipeWire cards (`pactl list cards short` returning empty) when connecting Bluetooth audio devices on modern Arch/Manjaro Linux purely over an SSH session.

---

## Problem Context

1. **Headless SSH Limitations:** `systemd-logind` does not assign a physical PAM seat (`seat0`) to SSH sessions. 
2. **WirePlumber Seat Requirement:** By default, WirePlumber's Bluetooth monitor waits for an active graphical desktop seat before initializing A2DP/HFP audio endpoints on D-Bus.
3. **Connection Handshake Failure:** Without WirePlumber registering the Audio Sink endpoint with BlueZ (`org.bluez`), BlueZ rejects the Bluetooth handshake, throwing `org.bluez.Error.Failed br-connection-unknown`.

---

## Step-by-Step Solution

### 1. Disable WirePlumber Seat Monitoring
Force WirePlumber to monitor and register Bluetooth audio devices even in headless, seatless SSH environments.

1. Create the WirePlumber user override directory:
   ```bash
   mkdir -p ~/.config/wireplumber/wireplumber.conf.d/
   ```

2. Create the override configuration file:
   ```bash
   nano ~/.config/wireplumber/wireplumber.conf.d/force-bluetooth.conf
   ```

3. Add the following lines:
   ```ini
   wireplumber.profiles = {
     main = {
       monitor.bluez.seat-monitoring = disabled
     }
   }
   ```

---

### 2. Configure D-Bus Permissions for Unprivileged SSH Users
Allow the unprivileged user session to send and receive D-Bus signals to/from `org.bluez`.

1. Create the system D-Bus directory (if missing):
   ```bash
   sudo mkdir -p /etc/dbus-1/system.d/
   ```

2. Create the custom D-Bus policy file:
   ```bash
   sudo nano /etc/dbus-1/system.d/bluetooth-ssh.conf
   ```

3. Paste the following XML policy (replace `1000` with your user's UID via `id -u` if different):
   ```xml
   <!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
    "[http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd](http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd)">
   <busconfig>
     <policy user="1000">
       <allow send_destination="org.bluez"/>
       <allow receive_sender="org.bluez"/>
     </policy>
   </busconfig>
   ```

4. Reload D-Bus and restart the Bluetooth service:
   ```bash
   sudo systemctl reload dbus
   sudo systemctl restart bluetooth
   ```

---

### 3. Configure Shell Environment & Restart Audio Services
Ensure your SSH shell environment is bound to the running systemd user bus and PipeWire PulseAudio socket.

1. Add environment exports to your `~/.bashrc` for persistence:
   ```bash
   echo 'export XDG_RUNTIME_DIR="/run/user/$(id -u)"' >> ~/.bashrc
   echo 'export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"' >> ~/.bashrc
   echo 'export PULSE_SERVER="unix:/run/user/$(id -u)/pulse/native"' >> ~/.bashrc
   source ~/.bashrc
   ```

2. Enable systemd user service lingering so daemons persist across SSH logons:
   ```bash
   sudo loginctl enable-linger $USER
   ```

3. Restart the PipeWire and WirePlumber user stack:
   ```bash
   systemctl --user restart pipewire pipewire-pulse wireplumber
   ```

---

### 4. Pair, Trust, and Connect
Once WirePlumber initializes the Bluetooth endpoints on D-Bus without waiting for a seat, complete the Bluetooth connection process.

1. Launch `bluetoothctl`:
   ```bash
   bluetoothctl
   ```

2. Execute the setup sequence:
   ```text
   power on
   agent NoInputNoOutput
   default-agent
   scan on
   ```

3. Once your device MAC address appears in the logs:
   ```text
   pair MAC_ADDRESS
   trust MAC_ADDRESS
   connect MAC_ADDRESS
   ```

---

### 5. Routing Audio & Verification

1. Verify that `pactl` now recognizes PipeWire endpoints:
   ```bash
   pactl list cards short
   ```

2. Set high-quality audio (A2DP Sink) profile and default output sink:
   ```bash
   # Set profile to high-fidelity A2DP Sink
   pactl set-card-profile bluez_card.MAC_ADDRESS_WITH_UNDERSCORES a2dp-sink

   # Set as system default output sink
   pactl set-default-sink bluez_output.MAC_ADDRESS_WITH_UNDERSCORES.1
   ```