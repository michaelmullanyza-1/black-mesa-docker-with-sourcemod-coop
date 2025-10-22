# Use a stable Ubuntu LTS for 32-bit compatibility
FROM ubuntu:22.04

# Enable 32-bit architecture and install all dependencies
RUN dpkg --add-architecture i386 && \
    apt update && apt -y full-upgrade && \
    apt -y install wget unzip screen curl lib32gcc-s1 lib32stdc++6 lib32z1 lib32ncurses6 ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user to run the server
RUN adduser --disabled-password --gecos "" steam

# Create necessary directories
RUN mkdir -p /home/steam/steamcmd /home/steam/mesa /home/steam/mesa/bms

# Set working directory to SteamCMD
WORKDIR /home/steam/steamcmd

# Download and extract SteamCMD
RUN wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz && \
    chmod +x steamcmd.sh

# Run SteamCMD to install Black Mesa (run as root)
RUN ./steamcmd.sh +force_install_dir /home/steam/mesa +login anonymous +app_update 346680 +quit

# Switch to non-root user
USER steam

# Ensure Steam client linkage
RUN mkdir -p /home/steam/.steam/sdk32 && \
    ln -s /home/steam/steamcmd/linux32/steamclient.so /home/steam/.steam/sdk32/steamclient.so

# Set working directory for mods
WORKDIR /home/steam/mesa

# Download and extract SourceMod, MetaMod, and SourceCoop
RUN wget https://mms.alliedmods.net/mmsdrop/1.12/mmsource-1.12.0-git1156-linux.tar.gz && \
    tar -xvzf mmsource-1.12.0-git1156-linux.tar.gz -C /home/steam/mesa/bms && \
    wget https://sm.alliedmods.net/smdrop/1.12/sourcemod-1.12.0-git7163-linux.tar.gz && \
    tar -xvzf sourcemod-1.12.0-git7163-linux.tar.gz -C /home/steam/mesa/bms && \
    wget https://github.com/ampreeT/SourceCoop/releases/download/v1.5-beta2/SourceCoop-1.5-beta2-bms.zip && \
    unzip SourceCoop-1.5-beta2-bms.zip -d /home/steam/mesa/bms && \
    rm -f *.tar.gz *.zip

# Add your custom start script and server config
WORKDIR /home/steam
ADD start.sh /home/steam/start.sh
ADD server.cfg /home/steam/server.cfg
RUN chmod +x /home/steam/start.sh && \
    mv /home/steam/mesa/bms/cfg/server.cfg /home/steam/mesa/bms/cfg/server.cfg.bck && \
    mv /home/steam/server.cfg /home/steam/mesa/bms/cfg/server.cfg

# Expose the game ports
EXPOSE 27315-27330/udp
EXPOSE 27315-27330/tcp

# Set working directory for server runtime
WORKDIR /home/steam/mesa

# Run the server
CMD ["/home/steam/start.sh"]
