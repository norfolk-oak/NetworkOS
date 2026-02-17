FROM ubuntu:22.04

LABEL maintainer="NetworkOS Project"

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/root
ENV DISPLAY=:1
ENV VNC_RESOLUTION=1024x768
ENV NOVNC_PORT=8080

# Optional noVNC basic auth (set NOVNC_PASSWORD at runtime to enable)
ENV NOVNC_USER=admin
ENV NOVNC_PASSWORD=""

# 0) Enable 32-bit architecture for Wine (needed for many Windows apps)
RUN dpkg --add-architecture i386

# 1) Desktop + VNC/noVNC + browsers + network toolkit + ping + wine
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Desktop
    lxde-core lxterminal dbus-x11 x11-xserver-utils \
    # VNC/noVNC
    tigervnc-standalone-server novnc websockify \
    # Base utilities
    wget curl gpg git python3 sudo ca-certificates \
    # Ping / ICMP utilities
    iputils-ping iputils-tracepath \
    # Networking tools (expanded)
    iproute2 traceroute mtr dnsutils \
    nmap masscan arp-scan netdiscover fping \
    tcpdump tshark tcpflow wireshark \
    iperf3 ethtool ipcalc net-tools lsof whois \
    netcat-openbsd socat \
    # Wine (Windows apps)
    wine64 wine32 winetricks cabextract fonts-wine \
    # Browser(s)
    firefox \
    # Chrome runtime deps that often matter in minimal images
    fonts-liberation libasound2 libatk-bridge2.0-0 libatk1.0-0 libcups2 \
    libdrm2 libgbm1 libgtk-3-0 libnss3 libxss1 libxcomposite1 libxrandr2 \
    libxdamage1 libxkbcommon0 xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# 2) Install Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub \
      | gpg --dearmor > /usr/share/keyrings/google-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-archive-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
      > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && apt-get install -y --no-install-recommends google-chrome-stable && \
    rm -rf /var/lib/apt/lists/* && \
    sed -i 's|HERE/chrome"|HERE/chrome" --no-sandbox --disable-dev-shm-usage --disable-gpu|g' \
      /opt/google/chrome/google-chrome

# 3) Desktop Icons
RUN mkdir -p /root/Desktop && \
    cat > /root/Desktop/wireshark.desktop <<'EOF'
[Desktop Entry]
Type=Application
Name=Wireshark
Exec=wireshark
Icon=wireshark
Categories=Network;
EOF
RUN chmod +x /root/Desktop/wireshark.desktop

# 4) noVNC default landing page (autoconnect + scaling)
RUN echo '<html><head><meta http-equiv="refresh" content="0; url=vnc.html?autoconnect=true&resize=scale"></head></html>' \
  > /usr/share/novnc/index.html

# 5) Wallpaper (SAFE: include file in build context)
COPY vista.jpg /usr/share/backgrounds/vista.jpg

RUN mkdir -p /root/.config/pcmanfm/LXDE && \
    cat > /root/.config/pcmanfm/LXDE/desktop-items-0.conf <<'EOF'
[*]
wallpaper_mode=stretch
wallpaper=/usr/share/backgrounds/vista.jpg
desktop_bg=#000000
show_documents=0
show_trash=1
show_mounts=1
EOF

# 6) Entrypoint (adds optional noVNC Basic Auth)
RUN cat > /entrypoint.sh <<'EOF'
#!/usr/bin/env bash
set -e

DISP_NUM="${DISPLAY#:}"
VNC_PORT="$((5900 + DISP_NUM))"

rm -rf /tmp/.X11-unix /tmp/.X*-lock || true

vncserver "${DISPLAY}" \
  -SecurityTypes None \
  -geometry "${VNC_RESOLUTION}" \
  -xstartup /usr/bin/startlxde

# If NOVNC_PASSWORD is set, enable Basic Auth for noVNC/websockify
AUTH_ARG=""
if [ -n "${NOVNC_PASSWORD:-}" ]; then
  mkdir -p /etc/novnc
  printf "%s:%s\n" "${NOVNC_USER:-admin}" "${NOVNC_PASSWORD}" > /etc/novnc/htpasswd
  AUTH_ARG="--web-auth /usr/share/novnc --cert none --ssl-only 0 --auth-plugin BasicHTTPAuth --auth-source /etc/novnc/htpasswd"
  # Note: above uses websockify auth plugin if available; fallback below if not.
fi

# Prefer the built-in noVNC launch script; enable auth if supported
# Many distros support: --basic-auth user:pass
if [ -n "${NOVNC_PASSWORD:-}" ]; then
  exec /usr/share/novnc/utils/launch.sh \
    --vnc "localhost:${VNC_PORT}" \
    --listen "0.0.0.0:${NOVNC_PORT}" \
    --basic-auth "${NOVNC_USER:-admin}:${NOVNC_PASSWORD}"
else
  exec /usr/share/novnc/utils/launch.sh \
    --vnc "localhost:${VNC_PORT}" \
    --listen "0.0.0.0:${NOVNC_PORT}"
fi
EOF
RUN chmod +x /entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
