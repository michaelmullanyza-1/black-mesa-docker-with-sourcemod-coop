# 🧪 Black Mesa Dedicated Server (Docker + SourceMod + SourceCoop)

This project provides a **lightweight Dockerized Black Mesa dedicated server** with **SourceMod** and **SourceCoop** support.  
It automatically installs SteamCMD, the Black Mesa server, and required mods inside the container — all you need is Docker.

---

## 🚀 Features

- 🐳 **Docker-based** — clean, portable, and isolated server setup  
- 🕹️ **SteamCMD auto-installs** Black Mesa dedicated server  
- 🔧 **Automatic mod setup** — installs MetaMod, SourceMod, and SourceCoop  
- 💾 **Persistent data volume** — keeps maps, configs, and mods between rebuilds  
- ⚙️ **Configurable startup** via `server.cfg`  
- 📦 **Simple deployment** via `docker compose`

---

## 📁 Project Structure

```
black-mesa-docker/
│
├── Dockerfile          # Builds the lightweight Ubuntu + SteamCMD base
├── docker-compose.yml  # Defines container, ports, and volumes
├── start.sh            # Runtime script that installs & launches the server
├── server.cfg          # Your server configuration
└── data/               # Created automatically for persistent game data
```

---

## 🧰 Prerequisites

- Docker Engine 24+  
- Docker Compose 2.0+  
- At least **20 GB of free disk space** (first build downloads all server files)  

---

## ⚙️ Setup

### 1️⃣ Clone this repository
```bash
git clone https://github.com/michaelmullanyza-1/black-mesa-docker-with-sourcemod-coop.git
cd black-mesa-docker-with-sourcemod-coop
```

### 2️⃣ Build and start the container
```bash
docker compose build
docker compose up -d
```

The first launch will:
- Install SteamCMD  
- Download and validate Black Mesa server  
- Install MetaMod, SourceMod, and SourceCoop  
- Launch the game server automatically  

---

## 🧩 Configuration

### 🔧 `server.cfg`
You can edit `server.cfg` in the root directory before or after running the server.  
It’s automatically copied into the container at startup.

Example:
```cfg
hostname "Black Mesa Co-op Server"
rcon_password "changeme"
sv_lan 0
sv_pure 0
mp_teamplay 1
mp_friendlyfire 0
sv_maxrate 0
sv_minrate 30000
sv_maxupdaterate 100
sv_minupdaterate 30
```

---

## 🔌 Networking

| Port Range | Protocol | Purpose                  |
|-------------|-----------|--------------------------|
| 27315–27316 | TCP/UDP   | Game, RCON, and client communication |

Make sure to open/forward these ports on your router or firewall if you want public players to connect.

---

## 💾 Persistent Data

All game data, mods, and configs are stored in the `./data` folder on your host machine.

This means you can:
- Rebuild or update the image freely  
- Keep your maps, plugins, and configs intact  

---

## 🧠 Useful Commands

| Action | Command |
|--------|----------|
| View logs | `docker logs -f blackmesa_server` |
| Stop server | `docker compose down` |
| Restart server | `docker compose restart` |
| Enter container shell | `docker exec -it blackmesa_server bash` |
| Update Black Mesa manually | `docker exec -it blackmesa_server /home/steam/start.sh` |

---

## 🧩 Mod Management

The container automatically downloads and installs:
- **MetaMod:** Core mod loader  
- **SourceMod:** Plugin framework  
- **SourceCoop:** Cooperative multiplayer mod for Black Mesa  

They’re stored inside `data/bms/addons/`.

---

## ⚡ Tips

- The first build can take several minutes (SteamCMD + mods).  
- After that, container restarts are near-instant.  
- Adjust CPU/memory limits in `docker-compose.yml` if needed.

---

## 🧰 Troubleshooting

### ❌ `exit code 100` during apt install
This usually means a missing package source or outdated base image.  
**Fix:** Rebuild with `--no-cache` to refresh all package sources.
```bash
docker compose build --no-cache
```

### ❌ `exit code 3` when downloading steamcmd
Steam’s CDN occasionally moves files.  
**Fix:** Retry the build after a few minutes — or manually verify the link is reachable:
```bash
wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
```

### ❌ Missing `srcds_run` or game files
If the container logs show `No such file or directory` for `/home/steam/mesa/srcds_run`, the SteamCMD download likely failed mid-way.  
**Fix:** Rebuild cleanly and check your disk space.
```bash
docker compose down -v
docker compose build --no-cache
docker compose up -d
```

### ⚠️ Container keeps restarting
This happens when the server crashes or an install loop runs endlessly.  
**Fix:** Inspect logs with:
```bash
docker logs -f blackmesa_server
```

---

## 🧑‍💻 Maintainer

**Michael Mullany**  
[GitHub: michaelmullanyza-1](https://github.com/michaelmullanyza-1)
