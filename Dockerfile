# Base image
FROM ubuntu:22.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV STEAMCMDDIR=/home/steam/steamcmd
ENV MESADIR=/home/steam/mesa

# Install dependencies
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install wget unzip adduser screen lib32gcc-s1 lib32stdc++6 lib32z1 lib32ncurses6 ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

# Create steam user
RUN adduser --disabled-password --gecos "" steam

# Create directories
RUN mkdir -p $STEAMCMDDIR $MESADIR/bms

# Switch to steam user
USER steam
WORKDIR $STEAMCMDDIR

# Download SteamCMD
RUN wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz

# Expose ports for Black Mesa
EXPOSE 27315-27330/udp
EXPOSE 27315-27330/tcp

# Switch to home directory
WORKDIR /home/steam

# Add start script and server.cfg (your repo must have these)
ADD start.sh /home/steam/start.sh
ADD server.cfg /home/steam/server.cfg
RUN chmod +x /home/steam/start.sh

# Set entrypoint
CMD ["/home/steam/start.sh"]
