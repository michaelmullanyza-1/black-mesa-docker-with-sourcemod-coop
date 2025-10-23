#!/bin/bash
set -e

SERVER_DIR="/home/steam/mesa"
STEAMCMD="/home/steam/steamcmd/steamcmd.sh"
BMS_APP_ID=346680

echo "=== Updating Black Mesa Dedicated Server ==="
$STEAMCMD +force_install_dir "$SERVER_DIR" +login anonymous +app_update $BMS_APP_ID validate +quit

cd "$SERVER_DIR"

# Ensure folder structure
mkdir -p "$SERVER_DIR/bms/cfg"

# Install mods if missing (as before)
# MetaMod
if [ ! -d "$SERVER_DIR/bms/addons/metamod" ]; then
  echo "Installing MetaMod..."
  wget -q https://mms.alliedmods.net/mmsdrop/1.12/mmsource-1.12.0-git1156-linux.tar.gz
  tar -xzf mmsource-1.12.0-git1156-linux.tar.gz -C "$SERVER_DIR/bms"
  rm mmsource-1.12.0-git1156-linux.tar.gz
fi

# SourceMod
if [ ! -d "$SERVER_DIR/bms/addons/sourcemod" ]; then
  echo "Installing SourceMod..."
  wget -q https://sm.alliedmods.net/smdrop/1.12/sourcemod-1.12.0-git7163-linux.tar.gz
  tar -xzf sourcemod-1.12.0-git7163-linux.tar.gz -C "$SERVER_DIR/bms"
  rm sourcemod-1.12.0-git7163-linux.tar.gz
fi

# SourceCoop
if [ ! -d "$SERVER_DIR/bms/addons/sourcemod/plugins/sourcecoop" ]; then
  echo "Installing SourceCoop..."
  wget -q https://github.com/Benoist3012/SourceCoop/releases/download/1.5-beta2/SourceCoop-1.5-beta2-bms.zip
  unzip -o SourceCoop-1.5-beta2-bms.zip -d "$SERVER_DIR/bms"
  rm SourceCoop-1.5-beta2-bms.zip
fi

# Copy server config
cp /home/steam/server.cfg "$SERVER_DIR/bms/cfg/server.cfg"

echo "=== Starting Black Mesa Dedicated Server ==="
cd "$SERVER_DIR"

# Run the server
./srcds_run -game bms -secure -port 27315 +clientport 27316 +maxplayers 8 +map bm_c0a0a +exec server.cfg
