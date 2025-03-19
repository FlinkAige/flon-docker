# Stage 1: Build flon.cdt
FROM ubuntu:18.04 as builder

# Install dependencies and build tools
RUN apt-get update && apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git clang lldb libclang-dev cmake make automake libbz2-dev libssl-dev \
    libgmp3-dev autotools-dev build-essential libicu-dev python2.7-dev \
    autoconf libtool curl zlib1g-dev doxygen graphviz libncurses5-dev \
    libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Python 3.7.4 and development files
RUN curl -LO https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tgz && \
    tar xzf Python-3.7.4.tgz && \
    cd Python-3.7.4 && \
    ./configure --enable-optimizations && \
    make -j$(nproc) altinstall && \
    cd .. && \
    rm -rf Python-3.7.4 Python-3.7.4.tgz && \
    ln -sfn /usr/local/bin/python3.7 /usr/local/bin/python3 && \
    apt-get update && apt-get install -y python3.7-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Verify Python installation
RUN python3 --version && \
    ls /usr/local/include/python3.7m && \
    ls /usr/local/lib/python3.7/config-3.7m-x86_64-linux-gnu

# Clone and build flon.cdt
RUN git clone --recursive https://github.com/fullon-labs/cdt.git /flon.cdt && \
    cd /flon.cdt && \
    mkdir build && cd build && \
    cmake -DPython_ROOT_DIR=/usr/local .. && \
    make -j$(nproc)

# Generate the package
RUN cd /flon.cdt/build/packages && bash generate_package.sh deb

# Stage 2: Create runtime environment
FROM phusion/baseimage:bionic-1.0.0

# Install runtime dependencies
RUN apt-get update && apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libbz2-dev libssl-dev libgmp3-dev libicu-dev python2.7-dev \
    zlib1g-dev libtinfo5 libgdbm-dev libnss3-dev libreadline-dev libffi-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up working directory
RUN mkdir -p /opt/flon-cdt
WORKDIR /opt/flon-cdt

# Copy the built package from the builder stage
COPY --from=builder /flon.cdt/build/packages/flon.cdt_1.7.5-1_amd64.deb /tmp/flon.cdt.deb

# Install the package and clean up
RUN apt-get update && \
    apt-get install -y /tmp/flon.cdt.deb && \
    rm -rf /tmp/flon.cdt.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Default command (optional)
CMD ["bash"]