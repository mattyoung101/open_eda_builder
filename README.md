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

Disclaimer: I am not a Docker expert, and this is not a full time project. These binaries may be out of date, blow
up your system, or not compile at all. Use at your own risk.

**Author:** Matt Young (m.young2@uqconnect.edu.au)

## Running the Docker container
TODO

## Using the builds
TODO

## Licence
The build scripts I have personally written are licenced under the Mozilla Public License v2.0. This is for the Docker
scripts only and has no relation to the outputted builds or your synthesised designs.

Each project that is downloaded and built is licenced under its own respective licences. The final binaries will be
licenced under the most restrictive licence in all the source code, which I believe at the moment is thankfully the 
rather permissive ISC licence.
