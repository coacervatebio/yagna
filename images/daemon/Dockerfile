FROM alpine:latest

RUN apk add jq

# Install yagna requestor
WORKDIR /home
ARG YAG_VER=v0.12.0
ADD "https://github.com/golemfactory/yagna/releases/download/${YAG_VER}/golem-requestor-linux-${YAG_VER}.tar.gz" .
RUN tar -xzf "golem-requestor-linux-${YAG_VER}.tar.gz"
RUN mv golem-requestor-linux-${YAG_VER}/* /usr/local/bin/
RUN rm -rf golem-requestor*

COPY start.sh /home/start.sh
ENTRYPOINT ["/bin/sh", "/home/start.sh"]