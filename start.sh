#!/bin/bash
set -e

STEAMCMD_DIR=/home/steam/steamcmd
GAME_DIR=/home/steam/mesa
BMS_DIR=$GAME_DIR/bms

mkdir -p $BMS_DIR/cfg

echo "Updating Black Mesa..."
$STEAMCMD_DIR/steamcmd.sh +force_install_dir $GAME_DIR +login anonymous +app_update 346680 +quit

echo "Downloading mods..."
cd $BMS_DIR

# Download mods if not present
[ ! -f mmsource-1.12.0-git1156-linux.tar.gz ] && \
    wget https://mms.alliedmods.net/mmsdrop/1.12/mmsource-1.12.0-git1156-linux.tar.gz
[ ! -f sourcemod-1.12.0-git7163-linux.tar.gz ] && \
    wget https://sm.alliedmods.net/smdrop/1.12/sourcemod-1.12.0-git7163-linux.tar.gz
[ ! -f SourceCoop-1.5-beta2-bms.zip ] && \
    wget https://github.com/ampreeT/SourceCoop/releases/download/v1.5-beta2/SourceCoop-1.5-beta2-bms.zip

echo "Installing mods..."
tar -xvzf mmsource-1.12.0-git1156-linux.tar.gz -C $BMS_DIR || true
tar -xvzf sourcemod-1.12.0-git7163-linux.tar.gz -C $BMS_DIR || true
unzip -o SourceCoop-1.5-beta2-bms.zip -d $BMS_DIR || true

# Ensure server.cfg is in place
if [ ! -f $BMS_DIR/cfg/server.cfg ]; then
    cp $BMS_DIR/cfg/server.cfg.bck $BMS_DIR/cfg/server.cfg 2>/dev/null || true
fi

echo "Starting Black Mesa server..."
$GAME_DIR/srcds_run -game bms -secure -port 27315 +clientport 27316 +maxplayers 10 +mp_teamplay 1 +exec server.cfg +map bm_c0a0a
