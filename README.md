# 🌐 NetworkOS

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![LXDE](https://img.shields.io/badge/Desktop-LXDE-blue?style=for-the-badge)
![noVNC](https://img.shields.io/badge/noVNC-Browser%20Access-green?style=for-the-badge)
![Wine](https://img.shields.io/badge/Wine-Windows%20Support-purple?style=for-the-badge)

---

## 🚀 Overview

**NetworkOS** is a browser-accessible Linux desktop (LXDE) built for:

- 🌐 Network analysis  
- 🔐 Security testing  
- 🖥 Sysadmin operations  
- 🧪 Lab environments  
- 🪟 Running Windows tools via Wine  

Everything runs inside a Docker container and is accessed via **noVNC** in your browser.

---

# 📦 Features

## 🖥 Desktop Environment
- LXDE lightweight GUI
- Browser access via noVNC
- Custom wallpaper support
- Angry IP Scanner desktop shortcut
- Auto-scaling display

---

## 🌐 Network Toolkit

### Discovery & Scanning
- `nmap`
- `masscan`
- `arp-scan`
- `netdiscover`
- `fping`
- **Angry IP Scanner (GUI)**

### Packet Analysis
- Wireshark (installed)
- `tcpdump`
- `tshark`
- `tcpflow`

### Connectivity & Diagnostics
- `ping`
- `tracepath`
- `traceroute`
- `mtr`
- `iperf3`
- `dnsutils`
- `whois`

---

# 🪟 Windows Applications (Preinstalled via Wine)

NetworkOS includes pre-installed Windows tools using Wine.

## Included Windows Software

### 📝 Notepad++
- Lightweight code editor
- Great for logs, configs, scripts
- Runs via Wine
- Desktop shortcut included

### 📦 WinRAR
- Archive manager
- Supports RAR, ZIP, 7z, TAR, etc.
- Desktop shortcut included

---

# 🪟 Wine Support

Wine is installed and configured with:

- Winecfg
- Wine File Manager
- Winetricks (GUI)

Wine prefix location:

```
/root/.wine
```

To install additional Windows programs:

```bash
wine installer.exe
```

To launch manually:

```bash
wine program.exe
```

---

# 🔐 noVNC Password Protection

NetworkOS uses nginx-based Basic Authentication in front of noVNC.

Enable authentication:

```bash
docker run -d \
  -p 8080:8080 \
  -e NOVNC_USER=admin \
  -e NOVNC_PASSWORD=SuperSecret123 \
  --name networkos \
  networkos
```

If `NOVNC_PASSWORD` is not set, no authentication is applied.

---

# 🚀 Quick Start

## Build

```bash
docker build -t networkos .
```

## Run

```bash
docker run -d \
  -p 8080:8080 \
  --cap-add NET_ADMIN \
  --cap-add NET_RAW \
  --name networkos \
  networkos
```

Open:

```
http://localhost:8080
```

---

# 💾 Persistence

To preserve installed Windows applications and Wine data:

```bash
docker run -d \
  -p 8080:8080 \
  -v $(pwd)/networkos_data:/root \
  -e NOVNC_PASSWORD=mypass \
  --name networkos \
  networkos
```

---

# ☸ Kubernetes / Cloud Deployments

This image is resource-heavy.

### Recommended:

- 4GB RAM minimum
- 6–8GB RAM recommended
- 2 vCPU minimum

If pods show:

```
Evicted
```

Increase memory limits.

---

# 🔒 Security Notes

- VNC runs internally without password.
- nginx protects noVNC when `NOVNC_PASSWORD` is set.
- Use HTTPS when exposing publicly.
- Recommended:
  - Reverse proxy
  - VPN
  - IP allowlisting

---

# 🧪 Use Cases

- Network lab environment
- Windows vendor tools in Linux container
- Remote troubleshooting desktop
- Temporary security workstation

---

# 📜 License

MIT License (or your preferred license)
