#!/bin/bash

STEAMCMD_DIR=/home/steam/steamcmd
GAME_DIR=/home/steam/mesa
BMS_DIR=$GAME_DIR/bms

# Step 1: Download/update Black Mesa
echo "Updating Black Mesa..."
$STEAMCMD_DIR/steamcmd.sh +force_install_dir $GAME_DIR +login anonymous +app_update 346680 validate +quit

# Step 2: Install mods (Sourcemod + MetaMod + SourceCoop)
echo "Installing mods..."
mkdir -p $BMS_DIR
wget -q https://mms.alliedmods.net/mmsdrop/1.12/mmsource-1.12.0-git1156-linux.tar.gz
tar -xvzf mmsource-1.12.0-git1156-linux.tar.gz -C $BMS_DIR
wget -q https://sm.alliedmods.net/smdrop/1.12/sourcemod-1.12.0-git7163-linux.tar.gz
tar -xvzf sourcemod-1.12.0-git7163-linux.tar.gz -C $BMS_DIR
wget -q https://github.com/ampreeT/SourceCoop/releases/download/v1.5-beta2/SourceCoop-1.5-beta2-bms.zip
unzip -q SourceCoop-1.5-beta2-bms.zip -d $BMS_DIR
rm -f *.tar.gz *.zip

# Step 3: Copy server.cfg if needed
if [ ! -f $BMS_DIR/cfg/server.cfg ]; then
    cp /home/steam/server.cfg $BMS_DIR/cfg/server.cfg
fi

# Step 4: Start the Black Mesa server
echo "Starting Black Mesa server..."
$GAME_DIR/srcds_run -game bms -secure -port 27315 +clientport 27316 +maxplayers 10 +mp_teamplay 1 +exec server.cfg +map bm_c0a0a
