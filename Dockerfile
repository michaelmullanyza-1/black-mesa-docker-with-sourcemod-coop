# Base image
FROM ubuntu:22.04

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt update && apt -y install wget unzip screen lib32gcc-s1 lib32stdc++6 lib32z1 lib32ncurses6 ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN adduser --disabled-password --gecos "" steam

# Set up directories
RUN mkdir -p /home/steam/steamcmd /home/steam/mesa /home/steam/mesa/bms

# Download and install SteamCMD
WORKDIR /home/steam/steamcmd
RUN wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz && \
    chmod +x steamcmd.sh

# Switch to steam user
USER steam
WORKDIR /home/steam/mesa

# Download start.sh and server.cfg directly from GitHub
RUN curl -L -o /home/steam/start.sh https://raw.githubusercontent.com/michaelmullanyza-1/black-mesa-docker-with-sourcemod-coop/main/start.sh && \
    chmod +x /home/steam/start.sh

RUN curl -L -o /home/steam/server.cfg https://raw.githubusercontent.com/michaelmullanyza-1/black-mesa-docker-with-sourcemod-coop/main/server.cfg

# Expose ports
EXPOSE 27315-27330/udp
EXPOSE 27315-27330/tcp

# Default command starts the helper script
CMD ["/home/steam/start.sh"]
