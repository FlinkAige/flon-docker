# Stage 1: Build flon.cdt
FROM ubuntu:22.04 as builder

# Install dependencies and build tools
RUN apt-get update && apt-get install build-essential clang clang-tidy cmake git libxml2-dev \
            opam ocaml-interp python3 python3-pip time                     
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Python 3.7.4 and development files
RUN python3 -m pip install pygments

# Clone and build flon.cdt
RUN git clone --recursive https://github.com/fullon-labs/cdt.git /flon.cdt && \
    cd /flon.cdt && \
    export CCACHE_DISABLE=1 && \
    mkdir build && cd build && \
    cmake -DPython_ROOT_DIR=/usr/local .. && \
    make -j$(nproc)

RUN cd build/packages && bash ./generate_package.sh "deb" \
    && mv "$( ls -t flon.cdt*.deb | head -1 )" /flon.cdt.deb

## create flon.cdt runtime env
FROM phusion/baseimage:bionic-1.0.0

RUN apt-get update && apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git clang \
    lldb libclang-dev cmake make automake libbz2-dev libssl-dev \
    libgmp3-dev autotools-dev build-essential libicu-dev python2.7-dev \
    autoconf libtool curl zlib1g-dev doxygen graphviz \
    libncurses5-dev libtinfo5 libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev

RUN mkdir -p /opt/amax.cdt
WORKDIR /opt/amax.cdt
COPY --from=0 /flon.cdt.deb /flon.cdt.deb
RUN apt install /flon.cdt.deb
RUN rm -rf /flon.cdt.deb