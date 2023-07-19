FROM python:slim-bullseye

RUN apt-get update && \
apt-get install --no-install-recommends -y jq && \
apt-get autoclean && rm -rf /var/lib/apt/lists/*

# Install yagna requestor
WORKDIR /home
ARG YAG_VER=v0.12.2
ADD "https://github.com/golemfactory/yagna/releases/download/${YAG_VER}/golem-requestor-linux-${YAG_VER}.tar.gz" .
RUN tar -xzf "golem-requestor-linux-${YAG_VER}.tar.gz"
RUN mv golem-requestor-linux-${YAG_VER}/* /usr/local/bin/
RUN rm -rf golem-requestor*

# Install python deps
ARG YAP_VER=0.11.0
RUN pip install yapapi==${YAP_VER}

# Copy home including Dockerfile and hello_golem test script
# Run test script by overriding entrypoing with /home/hello_golem.py
COPY . /home

ENTRYPOINT ["/bin/sh", "/home/start.sh"]