FROM ubuntu:22.04

RUN apt update && apt -y full-upgrade && \
    apt -y install wget unzip adduser screen ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

RUN adduser steam

RUN mkdir -p /home/steam/steamcmd /home/steam/mesa /home/steam/mesa/bms

WORKDIR /home/steam/steamcmd

RUN wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz \
    && tar -xvzf steamcmd_linux.tar.gz

RUN chmod +x steamcmd.sh
RUN ./steamcmd.sh +force_install_dir /home/steam/mesa +login anonymous +app_update 346680 +quit

USER steam

RUN mkdir -p /home/steam/.steam \
    && mkdir -p /home/steam/.steam/sdk32 \
    && ln -s /home/steam/steamcmd/linux32/steamclient.so /home/steam/.steam/sdk32/steamclient.so

WORKDIR /home/steam/mesa

RUN wget https://mms.alliedmods.net/mmsdrop/1.12/mmsource-1.12.0-git1156-linux.tar.gz \
    && tar -xvzf mmsource-1.12.0-git1156-linux.tar.gz -C /home/steam/mesa/bms \
    && wget https://sm.alliedmods.net/smdrop/1.12/sourcemod-1.12.0-git7163-linux.tar.gz \
    && tar -xvzf sourcemod-1.12.0-git7163-linux.tar.gz -C /home/steam/mesa/bms \
    && wget https://github.com/ampreeT/SourceCoop/releases/download/v1.5-beta2/SourceCoop-1.5-beta2-bms.zip \
    && unzip SourceCoop-1.5-beta2-bms.zip -d /home/steam/mesa/bms

RUN rm -f steamcmd_linux.tar.gz \
          mmsource-1.12.0-git1156-linux.tar.gz \
          sourcemod-1.12.0-git7163-linux.tar.gz \
          SourceCoop-1.5-beta2-bms.zip

WORKDIR /home/steam/

ADD start.sh /home/steam/start.sh
ADD server.cfg /home/steam/server.cfg
RUN chmod +x /home/steam/start.sh
RUN mv /home/steam/mesa/bms/cfg/server.cfg /home/steam/mesa/bms/cfg/server.cfg.bck \
    && mv /home/steam/server.cfg /home/steam/mesa/bms/cfg/server.cfg

EXPOSE 27315-27330/udp
EXPOSE 27315-27330/tcp
#ENTRYPOINT ["bash"]
WORKDIR /home/steam/mesa/
USER steam
CMD ["/home/steam/start.sh"]
