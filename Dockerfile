# Stage 1: Base image with SteamCMD
FROM ubuntu:22.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && apt -y install \
    wget unzip adduser screen \
    lib32gcc-s1 lib32stdc++6 lib32z1 lib32ncurses6 \
    ca-certificates curl locales \
    && rm -rf /var/lib/apt/lists/*

# Set locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Create steam user
RUN adduser --disabled-login --gecos "" steam

# Create directories
RUN mkdir -p /home/steam/steamcmd /home/steam/mesa
WORKDIR /home/steam/steamcmd

# Download SteamCMD
RUN wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    && tar -xvzf steamcmd_linux.tar.gz \
    && rm steamcmd_linux.tar.gz

# Make steamcmd executable
RUN chmod +x /home/steam/steamcmd/steamcmd.sh

# Switch to steam user
USER steam
WORKDIR /home/steam/mesa

# Copy start script (must exist in repo)
COPY start.sh /home/steam/start.sh
RUN chmod +x /home/steam/start.sh

# Expose server ports
EXPOSE 27315-27330/udp
EXPOSE 27315-27330/tcp

# Default command
CMD ["/home/steam/start.sh"]
