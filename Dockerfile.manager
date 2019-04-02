# specify the base image
FROM arm64v8/ubuntu:18.04

COPY qemu-aarch64-static /usr/bin

# install tools
RUN apt-get update \
  && apt-get install -y jq git python-pip libltdl7 libffi-dev

# Create app directory
WORKDIR /usr/src/app

# install docker-compose
RUN pip install docker-compose

# clone the repo
RUN git clone https://github.com/monero-ecosystem/monerobox.git \
  && cd monerobox \
  && git checkout container

COPY manager_entrypoint.sh .

ENTRYPOINT ["/usr/src/app/manager_entrypoint.sh"]

