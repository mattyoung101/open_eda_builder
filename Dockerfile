# Copyright (c) 2022 Matt Young
# 
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#
FROM open_eda_builder/base:latest

# Clone repositories
WORKDIR /build
RUN git clone https://github.com/steveicarus/iverilog.git && git clone https://github.com/yosyshq/yosys.git && \
    git clone --recursive https://github.com/YosysHQ/prjtrellis.git && git clone https://github.com/YosysHQ/nextpnr.git && \
    git clone https://github.com/verilator/verilator.git && git clone https://github.com/YosysHQ/icestorm.git

# Build Icarus Verilog
WORKDIR /build/iverilog
RUN sh autoconf.sh && ./configure && make -j$(nproc) && make install

# Build Verilator
WORKDIR /build/verilator
RUN autoconf && ./configure && make -j$(nproc) && make install

# Build Yosys
WORKDIR /build/yosys
# Unfortunately Yosys is still built with Make, not CMake, so this is how we have to edit the config file.
# This switches Clang-10 (Ubuntu default) to Clang-15, and enables ENABLE_NDEBUG which in turn enables -O3 for
# better performance
RUN sed -i "s/CXX = clang/CXX = clang-15/g" Makefile && sed -i "s/LD = clang++/LD = clang++-15/g" Makefile \
    && sed -i "s/ENABLE_NDEBUG := 0/ENABLE_NDEBUG := 1/g" Makefile
RUN make config-clang && make -j$(nproc) && make install

# Build Project Trellis (for Lattice ECP5 support)
WORKDIR /build/prjtrellis/libtrellis/
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr/local . && make -j$(nproc) && make install

# Build Project IceStorm (for Lattice ICE40 support)
WORKDIR /build/icestorm
RUN make -j$(nproc) && make install

# Build Nextpnr (ECP5, iCE40 & generic targets)
WORKDIR /build/nextpnr/
RUN cmake . -DARCH="ice40;ecp5;generic" -DTRELLIS_INSTALL_PREFIX=/usr/local -DBUILD_GUI=ON && make -j$(nproc) && make install

# Strip all binaries in the /usr/local/bin directory (reduce size of archive a little bit)
RUN find /usr/local/bin -maxdepth 1 -type f -exec strip --strip-unneeded {} \;

# Create a build archive using zstandard. Exclude directories that are useless or may conflict with the user's computer.
WORKDIR /build/
RUN tar --exclude="/usr/local/share/fonts" --exclude="/usr/local/share/ca-certificates" -cvf open_eda_builder.tar.zst \
    /usr/local/bin /usr/local/share /usr/local/lib /usr/local/include -I "zstd -T0 -19 --long"
