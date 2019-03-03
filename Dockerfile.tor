# specify the base image
FROM arm64v8/ubuntu:18.04

COPY qemu-aarch64-static /usr/bin

# install tools
RUN apt-get update \
  && apt-get install -y tor

# Create app directory
WORKDIR /usr/src/app

# Enable torsocks
RUN sed -i 's/#SOCKSPort 9050/SOCKSPort 0.0.0.0:9050/g' /etc/tor/torrc

ENTRYPOINT ["tor", "-f", "/etc/tor/torrc"]

