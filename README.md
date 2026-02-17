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

It provides a full GUI Linux environment that runs entirely inside a Docker container and is accessible via **noVNC** in your browser.

No VM required. No local installs required.

---

# 📦 Features

### 🖥 Desktop Environment
- LXDE lightweight GUI
- Accessible via browser (noVNC)
- Custom wallpaper support
- Wireshark desktop shortcut
- Auto-scaling display

### 🌐 Network Toolkit
- `nmap`
- `masscan`
- `arp-scan`
- `netdiscover`
- `fping`
- `ping`
- `tracepath`
- `traceroute`
- `mtr`
- `iperf3`
- `dnsutils`
- `whois`
- `netcat`
- `socat`
- `ethtool`
- `ipcalc`
- `net-tools`
- `lsof`

### 📡 Packet Capture
- Wireshark (GUI)
- `tcpdump`
- `tshark`
- `tcpflow`

### 🌍 Browsers
- Firefox
- Google Chrome

### 🪟 Windows Application Support
- Wine (64-bit + 32-bit)
- Winetricks
- Supports many legacy Windows networking tools

---

# 🔧 Requirements

- Docker 20+
- Linux host recommended for full packet capture support

---

# 🚀 Quick Start

## 🔨 Build

```bash
docker build -t networkos .
```

---

## ▶ Run (Basic)

```bash
docker run -d \
  -p 8080:8080 \
  --name networkos-lab \
  networkos
```

Then open:

```
http://localhost:8080
```

---

# 🔐 Enable Password Protection (Recommended)

NetworkOS supports optional **HTTP Basic Auth** for noVNC.

```bash
docker run -d \
  -p 8080:8080 \
  -e NOVNC_USER=admin \
  -e NOVNC_PASSWORD=SuperSecret123 \
  --name networkos-lab \
  networkos
```

If `NOVNC_PASSWORD` is not set, noVNC runs without authentication.

> ⚠ If exposing publicly, always use HTTPS via reverse proxy and IP restrictions.

---

# 💾 Persistence

By default, everything runs in memory.

To persist user data:

```bash
docker run -d \
  -p 8080:8080 \
  -v $(pwd)/networkos_data:/root \
  -e NOVNC_PASSWORD=mypass \
  --name networkos-lab \
  networkos
```

This preserves:
- Desktop files
- Wine installations
- Browser sessions
- User configs
- Installed tools

---

# 🐳 Recommended Docker Flags

Some tools require additional privileges.

## For ping, arp-scan, tcpdump, Wireshark capture:

```bash
docker run -d \
  -p 8080:8080 \
  --cap-add NET_ADMIN \
  --cap-add NET_RAW \
  networkos
```

## To scan the host LAN (Linux only):

```bash
docker run -d \
  --network host \
  --cap-add NET_ADMIN \
  --cap-add NET_RAW \
  networkos
```

---

# 🪟 Running Windows Tools (Wine)

Run an executable:

```bash
wine mytool.exe
```

Install a Windows application:

```bash
wine installer.exe
```

Wine data is stored in:

```
/root/.wine
```

Persist `/root` if you want to keep installations.

---

# 🔒 Security Notes

- VNC server runs internally without password.
- noVNC can be protected with `NOVNC_PASSWORD`.
- Always use HTTPS when exposing publicly.
- Consider:
  - Reverse proxy authentication
  - IP allowlisting
  - VPN-only access
  - Cloudflare Access / Zero Trust

---

# 🎯 Example Use Cases

- Network penetration testing lab
- Remote Wireshark workstation
- Browser-isolated admin workstation
- Running vendor Windows utilities
- Security training environment
- Temporary forensic workstation
- On-demand troubleshooting desktop

---

# 🌍 Access

After running:

```
http://your-server-ip:8080
```

If `NOVNC_PASSWORD` is set, you will be prompted for credentials.

---

# 🏷 Project Status

Active development. Contributions welcome.

---

# 📜 License

MIT License (or specify your preferred license)
