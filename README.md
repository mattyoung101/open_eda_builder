# Open EDA Builder
This repository contains Docker scripts to build some open-source EDA tools used in FPGA development, using
the latest available code on their respective Git repos. 

Builds are currently manually invoked by me on an ad-hoc basis when I remember, but usually about once a week. In the
near-ish future, I will set up a systemd timer that actually automatically builds every Monday at 4pm AEST,
but I haven't had time yet.

The builds are currently for Linux only, and are compiled under Ubuntu 20.04, so your mileage may vary on
other distributions. Scroll down to see more info about how the builds work and how to install them.

The following tools are currently built:

- Icarus Verilog
- Yosys
- Project Trellis (Yosys support for Lattice ECP5)
- Nextpnr (architectures: ECP5, with GUI support)

In the future, I might also add support to build the following:

- Verilator
- GTKWave
- More nextpnr architectures (e.g. iCE40)

**Disclaimer:** This repository is mainly for personal use by me on my systems. It may work on yours. That being said, 
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
well in there, so probably read that. I'm the only one with write access to the open_eda_builder repo, so you
won't be able to upload builds to _this_ repo, but you can always upload them to your own.

Dependencies needed to run a build are Docker, the GitHub CLI, make, tar and zstd.

## Future improvements
- Install and use mold linker to compile tools (should be faster)
- In the GitHub release notes, say which hash for each tool was used
- Compile additional tools and architectures (see intro section)

## Licence
The build scripts I have personally written are licenced under the permissive ISC licence. This is for the Docker
scripts only and has no relation to the generated binaries or your synthesised designs.

Each project that is downloaded and built is licenced under its own respective licences, and the final binaries
will in turn be licenced under those terms as well.
