# Copyright 2015-2017 Sean Nelson <audiohacked@gmail.com>
FROM openjdk:8-jre-alpine

ENV URL="https://www.feed-the-beast.com/projects/ftb-presents-direwolf20-1-12/files/2637279/download" \
    SERVER_FILE="FTB+Presents+Direwolf20+1.12-1.12.2-2.4.0-Server.zip" \
    SERVER_PORT=25565

WORKDIR /minecraft

USER root
COPY CheckEula.sh /minecraft/
RUN apk --no-cache add wget && \
    mkdir -p /minecraft/world && \
    wget -O ${SERVER_FILE} ${URL} && \
    unzip ${SERVER_FILE} && \
    chmod +rwx FTBInstall.sh ServerStart.sh CheckEula.sh && \
    sed -i '2i /bin/sh /minecraft/CheckEula.sh' /minecraft/ServerStart.sh && \
    /minecraft/FTBInstall.sh

EXPOSE ${SERVER_PORT}
VOLUME ["/minecraft/world", "/minecraft/backups"]
CMD echo "eula=true" > /minecraft/eula.txt && \
    /minecraft/ServerStart.sh
