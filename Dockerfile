FROM ubuntu:22.04

LABEL maintainer="NetworkOS Project"
ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/root
ENV DISPLAY=:1
ENV VNC_RESOLUTION=1280x720
# --- SET YOUR PASSWORD HERE ---
ENV VNC_PASSWORD=networkos_secure

# 1. Install XFCE4, VNC, NoVNC, and Networking tools
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies \
    tigervnc-standalone-server novnc websockify \
    wget curl gpg git python3 sudo net-tools iputils-ping \
    nmap wireshark tcpdump iperf3 mtr dnsutils firefox \
    && apt-get clean

# 2. Install Google Chrome with sandbox fix
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /usr/share/keyrings/google-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-archive-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && apt-get install -y google-chrome-stable && \
    sed -i 's|HERE/chrome\"|HERE/chrome\" --no-sandbox --disable-dev-shm-usage|g' /opt/google/chrome/google-chrome

# 3. Install WineHQ
RUN dpkg --add-architecture i386 && mkdir -pm755 /etc/apt/keyrings && \
    wget -O - https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key && \
    wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources && \
    apt-get update && apt-get install --install-recommends -y winehq-stable

# 4. Set up VNC Password
RUN mkdir -p /root/.vnc && \
    echo "$VNC_PASSWORD" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# 5. Set Default Page & Auto-Resize
RUN echo '<html><head><meta http-equiv="refresh" content="0; url=vnc.html?autoconnect=true&resize=scale"></head></html>' > /usr/share/novnc/index.html

# 6. Startup Script
RUN echo '#!/bin/bash\n\
rm -rf /tmp/.X11-unix /tmp/.X*-lock\n\
# Start VNC with password protection enabled\n\
vncserver -rfbauth /root/.vnc/passwd -geometry $VNC_RESOLUTION $DISPLAY -xstartup /usr/bin/startxfce4\n\
/usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen 8080' > /entrypoint.sh && \
chmod +x /entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
