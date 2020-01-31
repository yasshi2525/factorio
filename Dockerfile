FROM alpine

ENV VERSION "0.17.79"

WORKDIR /usr/local

RUN apk add --no-cache curl

RUN curl -sSL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
         -o /etc/apk/keys/sgerrand.rsa.pub && \
    curl -sSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-2.30-r0.apk \
         -o /tmp/glibc-2.30-r0.apk && \
    apk add --no-cache /tmp/glibc-2.30-r0.apk && \
    rm -f /etc/apk/keys/sgerrand.rsa.pub /tmp/glibc-2.30-r0.apk

ARG UID=1000
ARG GID=1000

RUN addgroup -g ${GID} factorio && \
    adduser -u ${UID} -G factorio -DH factorio

RUN curl -sSL https://www.factorio.com/get-download/$VERSION/headless/linux64 \
         -o /tmp/factorio.tar.xz && \
    tar xf /tmp/factorio.tar.xz && \
    mkdir ./factorio/saves && \
    chown -R factorio:factorio ./factorio && \
    rm -f /tmp/factorio.tar.xz

WORKDIR /usr/local/factorio
COPY --chown=factorio:factorio ./docker-entrypoint.sh .

RUN chmod u+x ./docker-entrypoint.sh

USER factorio

EXPOSE 34197/udp

VOLUME [ "/usr/local/factorio/saves" ]

ENTRYPOINT [ "./docker-entrypoint.sh" ]