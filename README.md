# 🌐 NetworkOS

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E9433F?style=for-the-badge&logo=ubuntu&logoColor=white)
![Security](https://img.shields.io/badge/Security-Password--Protected-green?style=for-the-badge)

**NetworkOS** is a specialized, browser-accessible Linux desktop environment (XFCE) built for network analysis, security testing, and sysadmin tasks. It provides a full GUI toolkit that runs entirely inside a Docker container.

## 🚀 Quick Start

### Build the OS
```bash
docker build -t networkos .
```
### Run ths OS
```bash
docker run -d -p 8080:8080 -e VNC_PASSWORD=yourpassword --name networkos-lab networkos
```
### Persistence
docker run -d \
  -p 8080:8080 \
  -v $(pwd)/networkos_data:/root \
  -e VNC_PASSWORD=mypass \
  networkos

### What was added
1.  **Security Instructions:** Added the `-e VNC_PASSWORD` flag to the "Run" command so users know how to set their own password.
2.  **XFCE Mention:** Updated the description to reflect the move from LXDE to XFCE.
3.  **Badges:** Added a "Password-Protected" badge at the top to make it look professional.
4.  **Auto-Scaling Note:** Explicitly mentioned that the browser URL now handles scaling automatically.
