FROM ubuntu:20.04

# Install dependencies
# fix apt breaking: https://serverfault.com/a/1016972
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Australia/Brisbane
# Use Australian Ubuntu archive, https://gist.github.com/magnetikonline/3a841b5268d5581b4422
RUN sed --in-place --regexp-extended "s/(\/\/)(archive\.ubuntu)/\1au.\2/" /etc/apt/sources.list
RUN apt update && apt install -y build-essential clang-12 bison flex libreadline-dev gawk tcl-dev libffi-dev git \
    graphviz xdot pkg-config python3 libboost-system-dev libboost-python-dev libboost-filesystem-dev zlib1g-dev \
    gperf python3-dev libboost-all-dev libeigen3-dev qt5-default tar zstd clang cmake openocd
ARG CC=clang-12
ARG CXX=clang++-12
ENV CC=clang-12
ENV CXX=clang++-12
# TODO turn the above into a base image to save network every time we build??

# Clone repositories
WORKDIR /build
RUN git clone https://github.com/steveicarus/iverilog.git && git clone https://github.com/yosyshq/yosys.git && \
    git clone --recursive https://github.com/YosysHQ/prjtrellis.git && git clone https://github.com/YosysHQ/nextpnr.git

# Build Icarus
WORKDIR /build/iverilog
RUN sh autoconf.sh && ./configure && make -j32 && make install

# Build Yosys
WORKDIR /build/yosys
# TODO: make config-clang will use Clang 10, not Clang 12
RUN make config-clang && make -j32 && make install

# Build Project Trellis (for ECP5 support)
WORKDIR /build/prjtrellis/libtrellis/
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr/local . && make -j32 && make install

# Build Nextpnr
WORKDIR /build/nextpnr/
RUN cmake . -DARCH=ecp5 -DTRELLIS_INSTALL_PREFIX=/usr/local -DBUILD_GUI=ON && make -j32 && make install

# Create a build archive
WORKDIR /build/
RUN tar -cvf open_eda_builder.tar.zst /usr/local -I "zstd -T0 -19 --long"