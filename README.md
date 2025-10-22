# Black Mesa Dedicated Server Docker with SourceMod & SourceCoop

![Black Mesa](https://upload.wikimedia.org/wikipedia/en/f/f0/Black_Mesa_cover.jpg)

A Dockerized **Black Mesa dedicated server** with **SourceMod** and **SourceCoop** support, updated to use Ubuntu 22.04 and compatible 32-bit libraries.  
Easily deployable via **Docker** or **Portainer**.

---

## Features

- Ubuntu 22.04 LTS base for stable 32-bit support
- Automatic **SteamCMD** installation of Black Mesa (AppID: 346680)
- Includes **MetaMod:Source 1.12**, **SourceMod 1.12**, and **SourceCoop 1.5-beta2**
- Custom `start.sh` with configurable ports
- Configurable server via `server.cfg`
- Runs as non-root `steam` user for security
- Fully persistent game data via Docker volumes

---

## Requirements

- Docker 20+
- Docker Compose 1.29+ (for stack deployments)
- Portainer (optional, for GUI deployment)

---

## Quick Start (Docker CLI)

1. Clone this repository:

```bash
git clone https://github.com/michaelmullanyza-1/black-mesa-docker-with-sourcemod-coop.git
cd black-mesa-docker-with-sourcemod-coop
```

2. Build the Docker image:

```bash
docker build -t blackmesa:latest .
```

3. Run the container:

```bash
docker run -itd \
  --name mesa-server \
  -p 27315-27330:27315-27330/udp \
  -p 27315-27330:27315-27330/tcp \
  -v blackmesa-data:/home/steam/mesa \
  blackmesa:latest
```

---

## Quick Start (Portainer)

1. Open Portainer → **Stacks** → **Add stack**
2. Name the stack (e.g., `black-mesa-server`)
3. Paste this `docker-compose.yml`:

```yaml
version: "3.8"
services:
  blackmesa:
    build:
      context: https://github.com/michaelmullanyza-1/black-mesa-docker-with-sourcemod-coop.git
    container_name: black-mesa-server
    ports:
      - "27315-27330:27315-27330/udp"
      - "27315-27330:27315-27330/tcp"
    volumes:
      - blackmesa-data:/home/steam/mesa
    restart: unless-stopped

volumes:
  blackmesa-data:
```

4. Deploy the stack — Portainer will **build the image from GitHub** and start the server.

---

## Configuration

- **Ports:** `27315-27330` TCP/UDP (adjust in `start.sh` and docker run/compose if needed)
- **Server config:** `server.cfg` located in `/home/steam/mesa/bms/cfg/`
- **Start script:** `start.sh` located in `/home/steam/`  

Example `start.sh`:

```bash
/home/steam/mesa/srcds_run -game bms -secure -port 27315 +clientport 27316 +maxplayers 10 +mp_teamplay 1 +exec server.cfg +map bm_c0a0a
```

- **Volume:** `blackmesa-data` ensures game files and mods persist across container restarts

---

## Updating Mods / Server

1. Stop the container:

```bash
docker stop mesa-server
```

2. Rebuild the image (if updating SteamCMD or mods):

```bash
docker build -t blackmesa:latest .
```

3. Restart the container:

```bash
docker start mesa-server
```

---

## Notes

- Runs **as non-root user** `steam` for security
- Based on **Ubuntu 22.04 LTS** to ensure SteamCMD and 32-bit libraries work
- Compatible with **Portainer** stack deployments

---

## License

This project is provided **as-is**, for educational and personal server hosting purposes.  
Check the **[Steam EULA](https://store.steampowered.com/eula)** for hosting Black Mesa servers.

---

## Acknowledgments

- [Black Mesa](https://store.steampowered.com/app/362890/Black_Mesa/)  
- [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD)  
- [SourceMod](https://www.sourcemod.net/)  
- [MetaMod:Source](https://www.sourcemm.net/)  
- [SourceCoop](https://github.com/ampreeT/SourceCoop)
