# Open EDA Builder
## Deprecation Notice
This repo has been deprecated, as I have since moved to Arch Linux which ships more up-to-date packages
than Ubuntu. If you also choose to move to Arch, I suggest using the `verilator`, `yosys-nightly` and
`nextpnr-all-nightly` packages. Note that the last two come from the AUR.

Although I no longer need open_eda_builder for my personal use, the build scripts in the Dockerfiles should
work until either Ubuntu or the upstream projects break them. If they do break, I suggest you move to
[oss-cad-suite-build](https://github.com/YosysHQ/oss-cad-suite-build), or submit a fix via PR if you're feeling
brave.

Good luck with your FPGA development!

-------

This repository contains automated, bleeding-edge builds of various EDA tools used in FPGA development. 
The builds are automated using Docker and come direct from the latest commit on each project's git repo.

Builds are currently manually invoked by me on an ad-hoc basis when I remember, but usually about once a week.
If this repo is actively used by anyone, please let me know and I'll setup GitHub Actions to run it more consistently
in the cloud.

The builds are currently for Ubuntu 20.04 Linux only, so your mileage may vary on other distributions. I do
not plan to target other distributions (except Ubuntu 22.04) or other operating systems in the foreseeable
future, unless it's added via a PR. 

Scroll down to see more info about how the builds work and how to install them.

**The following tools are currently built:**

- Icarus Verilog
- Yosys (includes [AntMicro's SystemVerilog plugin](https://github.com/antmicro/yosys-systemverilog))
- Project Trellis (support for Lattice ECP5)
- Project Icestorm (support for Lattice iCE40)
- Nextpnr (architectures: ECP5, iCE40, Generic. GUI support enabled.)
- Verilator
- openFPGALoader

In the future, I might also add support to build the following:

- GTKWave
- Svls
- Any other project (open an issue - or a PR! - and I'll see what I can do)

**Why does this exist?** In recent years, several really cool open-source EDA tools and FPGA development tools
have been created. These tools are very actively maintained by their community, some featuring almost daily
commits. Most Linux distros don't ship packages for these tools, and if they do, the packages are usually too 
old to do cutting-edge FPGA work. The aim of open_eda_builder is to make it as easy as possible to get an up-to-date
Linux development environment for FPGA development set up.

**Disclaimer:** This repository is mainly for personal use by me on my systems. It may work on yours. That being said, 
I am not a Docker expert, and this is not a full time project. These binaries may be out of date, blow
up your system, or not compile at all. Use at your own risk.

**Author:** Matt Young (m.young2@uqconnect.edu.au)

## User guide
### Installing a build
Builds are upload as Zstandard compressed tarballs (.tar.zst), due to its excellent compression ratio.
You will need to install zstd (`sudo apt install zstd`) to decompress them using the tar utility.

**To install a build:**
- Go to the GitHub release page, pick the latest release, and download `open_eda_builder.tar.zst`
- Extract and install using: `sudo tar -xvf <path to open_eda_builder.tar.zst> -C /`
    - This will extract the build to /usr/local, but should not overwrite any additional files except those by previous
    open_eda_builder installs. If you don't trust me, you can open the .tar.zst file and check yourself.
    - That being said, I recognise this is potentially unsafe and reeks of bad security (extracting a tarball with
    root permissions to / is not ideal!). In the future, I will see if I can make a DEB package or bundle it in a
    directory like Yosys' oss-cad-suite-build does.

## Developer guide
### Basic build information
The build environment is Ubuntu 20.04. The compiler used is the latest available version of Clang, which at
the time of writing is Clang 15 (this is not shipped by default with Ubuntu, so an apt repository is added in the
base Dockerfile).

So far, the builds have only been tested against Ubuntu 20.04 derivatives (namely, Linux Mint 20). If you are
running an older/newer Ubuntu system, or a non-Ubuntu distribution, your mileage may vary.

### Performing a build
> **IMPORTANT NOTE: MAKEFILE MAY BE DESTRUCTIVE TO SOME DOCKER USERS.** Currently, it does a bunch of Docker prunes, in order
to force a rebuild, which is obviously terrible but I haven't got around to fixing it. Strongly advise **against**
performing a build if you have valuable Docker containers.

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
