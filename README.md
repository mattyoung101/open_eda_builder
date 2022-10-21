# Open EDA Builder
This repository contains a Docker container that builds some open-source EDA tools used in FPGA development, using
the latest available code on their respective Git repos. This repository is mainly for personal use by me, so your
mileage may vary.

The following tools are currently built:

- Icarus Verilog
- Yosys
- Project Trellis (Yosys support for Lattice ECP5)
- Nextpnr (architectures: ECP5, with GUI support)

In the future, I might also add support to build the following:

- Verilator
- GTKWave
- More nextpnr architectures (e.g. iCE40)

**Disclaimer:** I am not a Docker expert, and this is not a full time project. These binaries may be out of date, blow
up your system, or not compile at all. Use at your own risk.

**Author:** Matt Young (m.young2@uqconnect.edu.au)

## Running a build
To perform a full build, just run `make`. The Makefile has a lot of different targets for each part of the build 
(building the base image, the tools, extracting the archive, uploading, cleaning, etc). It's documented pretty
well in there, so probably read that, and you can run the individual tasks then.

## Installing a build
Builds are upload as Zstandard compressed tarballs (.tar.zst), due to its excellent compression ratio. 
However, you will need to install zstd to decompress them using the tar utility.

To install a build:
- Go to the GitHub release page, pick the latest release, and download open_eda_builder.tar.zst
- TODO

## Future improvements
- Install and use mold linker to compile tools (should be faster)
- In the GitHub release notes, say which hash was used
- Compile additional tools and architectures (see intro section)
- Use nprocs instead of hardcoding `make -j32` in Dockerfile

## Licence
The build scripts I have personally written are licenced under the permissive ISC licence. This is for the Docker
scripts only and has no relation to the outputted builds or your synthesised designs.

Each project that is downloaded and built is licenced under its own respective licences, and the final binaries
will in turn be licenced under those terms as well.
