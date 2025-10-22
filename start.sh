#!/bin/bash
set -e

STEAMCMD_DIR=/home/steam/steamcmd
GAME_DIR=/home/steam/mesa
BMS_DIR=$GAME_DIR/bms

mkdir -p $GAME_DIR
mkdir -p $BMS_DIR
mkdir -p $BMS_DIR/cfg

# Download/update Black Mesa
echo "Updating Black Mesa..."
$STEAMCMD_DIR/steamcmd.sh +force_install_dir $GAME_DIR +login anonymous +app_update 346680 validate +quit

# Make sure the server file exists
if [ ! -f $GAME_DIR/srcds_run ]; then
    echo "Error: srcds_run not found! Exiting."
    exit 1
fi

# Download mods
cd $BMS_DIR
wget -N https://mms.alliedmods.net/mmsdrop/1.12/mmsource-1.12.0-git1156-linux.tar.gz
tar -xvzf mmsource-1.12.0-git1156-linux.tar.gz

wget -N https://sm.alliedmods.net/smdrop/1.12/sourcemod-1.12.0-git7163-linux.tar.gz
tar -xvzf sourcemod-1.12.0-git7163-linux.tar.gz

wget -N https://github.com/ampreeT/SourceCoop/releases/download/v1.5-beta2/SourceCoop-1.5-beta2-bms.zip
unzip -o SourceCoop-1.5-beta2-bms.zip

# Copy server.cfg
cp -f /home/steam/server.cfg $BMS_DIR/cfg/server.cfg

# Start server
$GAME_DIR/srcds_run -game bms -secure -port 27315 +clientport 27316 +maxplayers 10 +mp_teamplay 1 +exec server.cfg +map bm_c0a0a
