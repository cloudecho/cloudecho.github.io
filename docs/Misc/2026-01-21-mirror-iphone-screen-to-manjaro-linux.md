---
layout: post
title:  "How to Mirror iPhone Screen to Manjaro Linux using UxPlay"
date:   2026-01-21 10:38:00 +0800
categories: Util
tags:
- docker
- cert
- tls
---


If you are running **Manjaro Linux** and want to mirror your iPhone or iPad screen to your desktop, **UxPlay** is the best open-source solution. It acts as an AirPlay server, allowing your Apple devices to see your PC as a "Screen Mirroring" target.

Since Manjaro is based on Arch, we have the advantage of using the **AUR** and the latest **GStreamer** plugins for low-latency streaming.

---

## 1. Prerequisites

Before we begin, ensure your iPhone and Manjaro PC are on the same Wi-Fi network.

## 2. Install Dependencies
AirPlay requires specific libraries for video decoding (H.264) and network discovery (mDNS). Open your terminal and run:

```bash
sudo pacman -Syu --needed base-devel cmake openssl libplist libdns_sd avahi libpulse gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav
```

## 3. Enable Network Discovery (Avahi)
AirPlay uses "Bonjour" to find devices. On Linux, this is handled by the Avahi daemon. You must enable and start it:

```bash
sudo systemctl enable --now avahi-daemon
```


## 4. Installation UxPlay

The easiest way to install UxPlay on Manjaro is through the AUR (Arch User Repository). You can use `pamac`(Manjaro's default package manager) or `yay`.

*Using Pamac*:

```bash
pamac build uxplay
```

*Using Yay:*

```sh
yay -S uxplay
```

## 5. Configuration: The Firewall

Manjaro often comes with a firewall enabled by default. If your iPhone cannot "see" your PC, you must open the ports used by AirPlay.

If you are using **UFW**, run:

```bash
sudo ufw allow 5353/udp
sudo ufw allow 7000,7001,7100,8000,8001/tcp
```

## 6. Usage: Mirroring your Screen

1. Launch UxPlay in your terminal:

```bash
uxplay
```

2. On your iPhone: 

- Swipe down to open the Control Center.
- Tap the Screen Mirroring icon (two overlapping rectangles).
- Select UxPlay (or your PC's hostname).

3. Enjoy: Your iPhone screen will now appear in a window on your Manjaro desktop.

## Pro Tip: Low-Latency Mode with AIC8800

If you are using a high-performance Wi-Fi adapter like the aic8800, you can reduce lag even further by creating a Wi-Fi Hotspot directly on Manjaro.

1. Go to Network Settings > Wi-Fi.
2. Enable Wi-Fi Hotspot.
3. Connect your iPhone to this hotspot.
4. Run uxplay.

By bypassing your home router and connecting directly to your PC's Wi-Fi card, you eliminate network congestion for a much smoother 60fps experience.

## Troubleshooting
- **No Sound?** Ensure `libpulse` or `pipewire-pulse` is installed and that the volume isn't muted in the `pavucontrol` mixer.

- **Laggy Video?** Ensure you have installed the `gst-libav` package for hardware-accelerated decoding.

---

*AI generated content*