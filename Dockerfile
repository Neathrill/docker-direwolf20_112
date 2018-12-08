# Copyright 2015-2017 Sean Nelson <audiohacked@gmail.com>
FROM openjdk:8-jre-alpine

ENV URL="https://www.feed-the-beast.com/projects/ftb-presents-direwolf20-1-12/files/2637279/download" \
    SERVER_FILE="FTB+Presents+Direwolf20+1.12-1.12.2-2.4.0-Server" \
    SERVER_PORT=25565

WORKDIR /minecraft

USER root
COPY CheckEula.sh /minecraft/
RUN adduser -D minecraft && \
    apk --no-cache add wget && \
    chown -R minecraft:minecraft /minecraft

USER minecraft
RUN mkdir -p /minecraft/world && \
    wget ${URL} && \
    unzip ${SERVER_FILE} && \
    chmod u+x FTBInstall.sh ServerStart.sh CheckEula.sh && \
    sed -i '2i /bin/sh /minecraft/CheckEula.sh' /minecraft/ServerStart.sh && \
    /minecraft/FTBInstall.sh

EXPOSE ${SERVER_PORT}
VOLUME ["/minecraft/world", "/minecraft/backups"]
CMD ["/bin/sh", "/minecraft/ServerStart.sh"]
