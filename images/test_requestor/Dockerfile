FROM python:slim-bullseye

# Install Yagna requestor
WORKDIR /home
ARG YAG_VER=v0.12.0
ADD "https://github.com/golemfactory/yagna/releases/download/${YAG_VER}/golem-requestor-linux-${YAG_VER}.tar.gz" .
RUN tar -xzf "golem-requestor-linux-${YAG_VER}.tar.gz"
RUN mv golem-requestor-linux-${YAG_VER}/* /usr/local/bin/
RUN rm -rf golem-requestor*

# Install python deps
ARG YAP_VER=0.10.0
RUN pip install yapapi==${YAP_VER}

COPY hello_golem.py /home/hello_golem.py

CMD ["python", "/home/hello_golem.py"]