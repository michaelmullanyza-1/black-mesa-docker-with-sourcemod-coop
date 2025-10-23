# Use Ubuntu LTS
FROM ubuntu:22.04

# Arguments for host UID/GID
ARG PUID=1000
ARG PGID=1000

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y install wget unzip adduser screen lib32gcc-s1 lib32stdc++6 lib32z1 lib32ncurses6 ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

# Create steam user matching host UID/GID
RUN groupadd -g $PGID steam && \
    useradd -m -u $PUID -g $PGID steam

# Switch to steam user
USER steam
WORKDIR /home/steam

# Download SteamCMD
RUN wget -q https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz

# Copy start script
COPY start.sh /home/steam/start.sh
RUN chmod +x /home/steam/start.sh

# Expose ports
EXPOSE 27315-27330/udp
EXPOSE 27315-27330/tcp

CMD ["/home/steam/start.sh"]
