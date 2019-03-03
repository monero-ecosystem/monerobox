# specify the base image
FROM arm64v8/ubuntu:18.04

COPY qemu-aarch64-static /usr/bin

# install tools
RUN apt-get update \
  && apt-get install -y wget

# Create app directory
WORKDIR /usr/src/app

# Download and uncompress monero CLI tools
#RUN wget -q https://downloads.getmonero.org/cli/linuxarm8 -O - | tar -jx
RUN wget -q https://bitcoin.org/bin/bitcoin-core-0.17.1/bitcoin-0.17.1-aarch64-linux-gnu.tar.gz -O - | tar zx

ENTRYPOINT ["/usr/src/app/bitcoin-0.17.1/bin/bitcoind", "-conf=/settings/bitcoind.conf"]

