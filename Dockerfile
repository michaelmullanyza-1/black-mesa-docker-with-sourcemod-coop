# Stage 1: Build stage - SteamCMD & Black Mesa
FROM ubuntu:22.04 AS builder

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt update && apt -y install wget unzip curl lib32gcc-s1 lib32stdc++6 lib32z1 lib32ncurses6 ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p /home/steam/steamcmd /home/steam/mesa

WORKDIR /home/steam/steamcmd

# Download and extract SteamCMD
RUN wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz && \
    chmod +x steamcmd.sh

# Install Black Mesa (CPU intensive, only runs once)
RUN ./steamcmd.sh +force_install_dir /home/steam/mesa +login anonymous +app_update 346680 +quit

# Stage 2: Final runtime image
FROM ubuntu:22.04

# Install minimal runtime dependencies
RUN dpkg --add-architecture i386 && \
    apt update && apt -y install wget unzip screen lib32gcc-s1 lib32stdc++6 lib32z1 lib32ncurses6 ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN adduser --disabled-password --gecos "" steam

# Copy Black Mesa from builder stage
COPY --from=builder /home/steam/mesa /home/steam/mesa

# Switch to steam user
USER steam
WORKDIR /home/steam/mesa

# Install mods
RUN mkdir -p bms && \
    wget https://mms.alliedmods.net/mmsdrop/1.12/mmsource-1.12.0-git1156-linux.tar.gz && \
    tar -xvzf mmsource-1.12.0-git1156-linux.tar.gz -C bms && \
    wget https://sm.alliedmods.net/smdrop/1.12/sourcemod-1.12.0-git7163-linux.tar.gz && \
    tar -xvzf sourcemod-1.12.0-git7163-linux.tar.gz -C bms && \
    wget https://github.com/ampreeT/SourceCoop/releases/download/v1.5-beta2/SourceCoop-1.5-beta2-bms.zip && \
    unzip SourceCoop-1.5-beta2-bms.zip -d bms && \
    rm -f *.tar.gz *.zip

# Add start script and server config
ADD start.sh /home/steam/start.sh
ADD server.cfg /home/steam/server.cfg
RUN chmod +x /home/steam/start.sh && \
    mv bms/cfg/server.cfg bms/cfg/server.cfg.bck && \
    mv /home/steam/server.cfg bms/cfg/server.cfg

# Expose ports
EXPOSE 27315-27330/udp
EXPOSE 27315-27330/tcp

# Run server
CMD ["/home/steam/start.sh"]
