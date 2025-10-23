# -------------------------------
# Black Mesa Dedicated Server (SteamCMD) - Lightweight Build
# -------------------------------

FROM ubuntu:22.04

LABEL maintainer="Michael Mullany <github.com/michaelmullanyza-1>"
LABEL description="Lightweight Black Mesa server base with SteamCMD"

# -------------------------------
# Install dependencies
# -------------------------------
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    wget \
    curl \
    unzip \
    tar \
    screen \
    lib32gcc-s1 \
    lib32stdc++6 \
    lib32z1 \
    lib32ncurses6 \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# -------------------------------
# Create steam user and dirs
# -------------------------------
RUN useradd -m steam && \
    mkdir -p /home/steam/steamcmd /home/steam/mesa && \
    chown -R steam:steam /home/steam

USER steam
WORKDIR /home/steam/steamcmd

# -------------------------------
# Download SteamCMD (with retry)
# -------------------------------
RUN bash -c "\
  for i in {1..5}; do \
    echo 'Downloading SteamCMD (attempt '$i')...' && \
    curl -fSL https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz -o steamcmd_linux.tar.gz && break || sleep 5; \
  done && \
  tar -xvzf steamcmd_linux.tar.gz && \
  rm steamcmd_linux.tar.gz"

# -------------------------------
# Copy startup files
# -------------------------------
WORKDIR /home/steam
COPY --chown=steam:steam start.sh server.cfg ./
RUN chmod +x start.sh

# -------------------------------
# Expose Black Mesa ports
# -------------------------------
EXPOSE 27315-27330/udp
EXPOSE 27315-27330/tcp

WORKDIR /home/steam/mesa
CMD ["/home/steam/start.sh"]
