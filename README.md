# Open EDA Builder
This repository contains automated, bleeding-edge builds of various EDA tools used in FPGA development. 
The builds are automated using Docker and come direct from the latest commit on each project's git repo.

Builds are currently manually invoked by me on an ad-hoc basis when I remember, but usually about once a week. In the
near-ish future, I will either set up a systemd timer for this or run it in the cloud, to make it more predictable.

The builds are currently for Linux only, and are compiled under Ubuntu 20.04, so your mileage may vary on
other distributions. I do not plan to target other distributions or other operating systems in the forseeable
future, unless it's added via a PR. Scroll down to see more info about how the builds work and how to install them.

**The following tools are currently built:**

- Icarus Verilog
- Yosys
- Project Trellis (support for Lattice ECP5)
- Project Icestorm (support for Lattice iCE40)
- Nextpnr (architectures: ECP5, iCE40, Generic. GUI support enabled.)
- Verilator

In the future, I might also add support to build the following:

- GTKWave
- svls?
- Any other project (open an issue - or a PR! - and I'll see what I can do)

**Why does this exist?** Open-source FPGA development is awesome. There is a great community of developers working
on all the above tools and making great strides every day. Because of the rapid pace of development, packages
shipped by your distribution (if they exist at all!) are usually too outdated. For example, the version of Icarus
Verilog shipped by Ubuntu 20.04 barely supports SystemVerilog at all compared to the latest Icarus Verilog. 
The aim of open_eda_builder is to make it a little less time consuming to get a good Linux dev environment for
FPGA development set up.

**Disclaimer:** This repository is mainly for personal use by me on my systems. It may work on yours. That being said, 
I am not a Docker expert, and this is not a full time project. These binaries may be out of date, blow
up your system, or not compile at all. Use at your own risk.

**Author:** Matt Young (m.young2@uqconnect.edu.au)

## User guide
### Installing a build
Builds are upload as Zstandard compressed tarballs (.tar.zst), due to its excellent compression ratio. This is
essential to tackle the miserable state of Australian NBN upload speeds.
You will need to install zstd (`sudo apt install zstd`) to decompress them using the tar utility.

**To install a build:**
- Go to the GitHub release page, pick the latest release, and download `open_eda_builder.tar.zst`
- Extract and install using: `sudo tar -xvf <path to open_eda_builder.tar.zst> -C /`
    - This will extract the build to /usr/local, but should not overwrite any additional files except those by previous
    open_eda_builder installs. If you don't trust me, you can open the .tar.zst file and check yourself.
    - That being said, I recognise this is potentially unsafe and reeks of bad security (extracting a tarball with
    root permissions to / is not ideal!). In the future, I will see if I can make a DEB package or bundle it in a
    directory like Yosys' oss-cad-suite-build does.

### open_eda_builder vs...
Yosys has another project called oss-cad-suite-build which is very similar to open_eda_builder. Here is a comparison so you
can make your own decision:

| **Item**            | **open_eda_builder** (this work)                  | **oss-cad-suite-build**                                                                                                   |
|---------------------|---------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------|
| Platforms supported | Linux x86_64                                      | Windows (x86_64), Mac (x86_64, ARM64),  Linux (x86_64, ARM32/64, RISC-V 64)                                               |
| Build times         | Roughly once a week                               | Every day consistently                                                                                                    |
| Installation        | Single command, system wide install to /usr/local | Extract archive and source environment script to use. Not supposed to invoke executables directly. Uses ld.so manually.   |
| Author              | Third party                                       | Maintained by Yosys itself                                                                                                |
| Build size          | ~90 MB, compressed (tar.zst)                      | ~480 MB, compressed (tar.gz)                                                                                              |

I created open_eda_builder because I was having trouble using nextpnr's GUI in oss-cad-suite-build, due to how it bundles
the binaries (it appears to involve manually invoking ld.so with a set of libraries), which was breaking Mesa for me. YMMV.

## Developer guide
### Basic build information
The build environment is Ubuntu 20.04. The compiler used is the latest available version of Clang, which at
the time of writing is Clang 15 (this is not shipped by default with Ubuntu, so an apt repository is added in the
base Dockerfile).

So far, the builds have only been tested against Ubuntu 20.04 derivatives (namely, Linux Mint 20). If you are
running an older/newer Ubuntu system, or a non-Ubuntu distribution, your mileage may vary.

### Performing a build
To perform a full build, just run `make`. The Makefile has a lot of different targets for each part of the build 
(building the base image, the tools, extracting the archive, uploading, cleaning, etc). It's documented pretty
well in there, so probably read that. I'm the only one with write access to the open_eda_builder repo, so you
won't be able to upload builds to _this_ repo, but you can always upload them to your own.

To perform a build, you will need the following tools installed on your _local_ system:

- Docker: a good install guide, including setting up rootless access, is [located here](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04)
- Make: `sudo apt install build-essential`
- GitHub CLI: instructions [here](https://github.com/cli/cli/blob/trunk/docs/install_linux.md)

On my AMD Ryzen 9 5950X with 32GB RAM, it takes around 22 minutes for a complete build and around 17 minutes for
an incremental build (i.e. not building the base Ubuntu image as well, just the EDA tools).

### Future improvements
- Install and use mold linker to compile tools (should be faster)
- In the GitHub release notes, say which hash for each tool was used
- Compile additional tools and architectures (see intro section)

## Licence
The build scripts I have personally written are licenced under the permissive ISC licence.

Each project that is downloaded and built is licenced under its own respective licences, and the final binaries
built for each project remain under those respective licences.
