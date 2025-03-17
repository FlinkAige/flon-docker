FROM ubuntu:20.04 as base


SHELL ["/bin/bash", "-c"]

# Build arguments
ARG BRANCH
ARG REPO
ARG CMAKE_BUILD_TYPE=Release

FROM base as builder
WORKDIR /root
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        autoconf2.13 \
        build-essential \
        cmake \
        curl \
        git \
        libboost-all-dev \
        libcurl4-openssl-dev \
        libgmp-dev \
        libpq-dev \
        libpqxx-dev \
        libssl-dev \
        ninja-build \
        openssl \
        python3-pkgconfig && \
    apt-get clean && \
    rm -rf /var/cache/apt/lists/*

    
RUN git clone --recursive "$REPO" -b "$BRANCH" .;

ENV DEBIAN_FRONTEND=noninteractive


RUN mkdir /root/history-tools/build
WORKDIR /root/history-tools/build
RUN cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DPostgreSQL_TYPE_INCLUDE_DIR=/usr/include/postgresql .. && \
    ninja
    # ctest --output-on-failure

FROM ubuntu:20.04
RUN echo "Asia/Shanghai" > /etc/timezone && \
    apt-get update && \
    apt-get install -y \
        netcat \
        openssl \
        postgresql-client && \
    apt-get clean && \
    rm -rf /var/cache/apt/lists/*

COPY --from=builder /root/history-tools/build/fill-pg /usr/local/bin/fill-pg