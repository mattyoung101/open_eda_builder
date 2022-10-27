# Open EDA Builder
This repository contains a Docker container that builds some open-source EDA tools used in FPGA development, using
the latest available code on their respective Git repos. The aim is to have this built automatically and uploaded every week
on a Monday (although this is not currently set up).

The builds are currently for Linux only, and are compiled under Ubuntu 20.04, so your mileage may vary on
other distributions. See the "Build info" section for more information about this.

The following tools are currently built:

- Icarus Verilog
- Yosys
- Project Trellis (Yosys support for Lattice ECP5)
- Nextpnr (architectures: ECP5, with GUI support)

In the future, I might also add support to build the following:

- Verilator
- GTKWave
- More nextpnr architectures (e.g. iCE40)

**Disclaimer:** This repository is mainly for personal use by me for my systems. It may work on yours. That being said, 
I am not a Docker expert, and this is not a full time project. These binaries may be out of date, blow
up your system, or not compile at all. Use at your own risk.

**Author:** Matt Young (m.young2@uqconnect.edu.au)

## Basic build information
The build environment is Ubuntu 20.04. The compiler used is the latest available version of Clang, which at
the time of writing is Clang 15 (this is not shipped by default with Ubuntu, so an apt repository is added in the
base Dockerfile).

So far, the builds have only been tested against Ubuntu 20.04 derivatives (namely, Linux Mint 20). If you are
running an older/newer Ubuntu system, or a non-Ubuntu distribution, your mileage may vary.

## Installing a build
Builds are upload as Zstandard compressed tarballs (.tar.zst), due to its excellent compression ratio. 
You will need to install zstd (`sudo apt install zstd`) to decompress them using the tar utility.

To install a build:
- Go to the GitHub release page, pick the latest release, and download open_eda_builder.tar.zst
- Extract and install using: `sudo tar -xvf <path to open_eda_builder.tar.zst> -C /`
    - This will extract the build to /usr/local, but should not overwrite any existing files, so should be safe
    - That being said, I recognise this is potentially unsafe and reeks of bad security (extracting a tarball with
    root permissions to / is not ideal!). In the future, I will see if I can make a DEB package or bundle it in a
    directory like Yosys' oss-cad-suite-build does.

## Performing a build
To perform a full build, just run `make`. The Makefile has a lot of different targets for each part of the build 
(building the base image, the tools, extracting the archive, uploading, cleaning, etc). It's documented pretty
well in there, so probably read that, and you can run the individual tasks then.

In order to perform a build you'll need to install Docker, the GitHub CLI and Make.

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
