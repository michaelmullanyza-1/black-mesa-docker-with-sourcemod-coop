FROM ubuntu:22.04

# Install dependencies
RUN apt update && apt -y install wget unzip adduser screen lib32gcc1 lib32stdc++6 lib32z1 lib32ncurses6 ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

# Create steam user
RUN adduser --disabled-login --gecos "" steam

# Create directories
RUN mkdir -p /home/steam/steamcmd /home/steam/mesa/bms/cfg

WORKDIR /home/steam/steamcmd

# Download SteamCMD
RUN wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz && \
    chmod +x steamcmd.sh

# Switch to steam user
USER steam
WORKDIR /home/steam/mesa

# Add server start script and default server.cfg
ADD start.sh /home/steam/start.sh
ADD server.cfg /home/steam/mesa/bms/cfg/server.cfg
RUN chmod +x /home/steam/start.sh

EXPOSE 27315-27330/udp 27315-27330/tcp

CMD ["/home/steam/start.sh"]
