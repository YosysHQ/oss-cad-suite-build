# OSS CAD Suite

[![linux-x64](https://github.com/YosysHQ/oss-cad-suite-build/actions/workflows/linux-x64.yml/badge.svg)](https://github.com/YosysHQ/oss-cad-suite-build/releases/latest)
[![darwin-x64](https://github.com/YosysHQ/oss-cad-suite-build/actions/workflows/darwin-x64.yml/badge.svg)](https://github.com/YosysHQ/oss-cad-suite-build/releases/latest)
[![windows-x64](https://github.com/YosysHQ/oss-cad-suite-build/actions/workflows/windows-x64.yml/badge.svg)](https://github.com/YosysHQ/oss-cad-suite-build/releases/latest)

[![linux-arm64](https://github.com/YosysHQ/oss-cad-suite-build/actions/workflows/linux-arm64.yml/badge.svg)](https://github.com/YosysHQ/oss-cad-suite-build/releases/latest)
[![darwin-arm64](https://github.com/YosysHQ/oss-cad-suite-build/actions/workflows/darwin-arm64.yml/badge.svg)](https://github.com/YosysHQ/oss-cad-suite-build/releases/latest)

## Introduction

OSS CAD Suite is a binary software distribution for a number of [open source software](https://en.wikipedia.org/wiki/Open-source_software) used in digital logic design. 
You will find tools for RTL synthesis, formal hardware verification, place & route, FPGA programming, and testing with support for HDLs like Verilog, Migen, and Amaranth.

OSS CAD Suite is a component of YosysHQ's Tabby CAD Suite:  
![image](https://user-images.githubusercontent.com/59544343/119006798-f8786100-b990-11eb-9535-cef67420ccfb.png)  
See [Tabby CAD Datasheet](https://www.yosyshq.com/tabby-cad-datasheet) for details on Tabby CAD Suite; see [OSS CAD Suite GitHub](https://github.com/YosysHQ/oss-cad-suite-build/) (this page) for details on OSS CAD Suite.

### RTL Synthesis 
 * [Yosys](https://github.com/YosysHQ/yosys) RTL synthesis with extensive Verilog 2005 support
 * [Amaranth](https://github.com/amaranth-lang/amaranth) refreshed Python toolbox for building complex digital hardware
 * [Migen](https://github.com/m-labs/migen) Python toolbox for building complex digital hardware
 * [ABC](https://people.eecs.berkeley.edu/~alanmi/abc/) A System for Sequential Synthesis and Verification
 * [GHDL](https://github.com/ghdl/ghdl) VHDL 2008/93/87 simulator (linux-x64, darwin-x64 and darwin-arm64 platforms only)
 
Did you know that the Tabby CAD version of yosys supports industry standard SystemVerilog, VHDL and SVA? 
Contact us at contact@yosyshq.com to arrange a free evaluation license.

### Plugins
 * [GHDL plugin](https://github.com/ghdl/ghdl-yosys-plugin) VHDL synthesis based on GHDL (linux-x64, darwin-x64 and darwin-arm64 platforms only)
 * [Slang plugin](https://github.com/povik/yosys-slang) SystemVerilog synthesis based on Slang

### Formal Tools
 * [sby (formerly SymbiYosys)](https://github.com/YosysHQ/sby) a front-end driver program for Yosys-based formal hardware verification flows.
 * [mcy](https://github.com/YosysHQ/mcy) Mutation Cover with Yosys
 * [eqy](https://github.com/YosysHQ/eqy) Equivalence Checking with Yosys
 * [sby-gui](https://github.com/YosysHQ/sby-gui) GUI for sby (formerly SymbiYosys)
 * [aiger](https://github.com/arminbiere/aiger) AIGER tools including bounded model checker
 * [avy](https://bitbucket.org/arieg/extavy) Interpolating Property Directed Reachability tool
 * [Boolector](https://github.com/Boolector/boolector) SMT solver and BTOR model checker
 * [Yices 2](https://github.com/SRI-CSL/yices2) SMT solver
 * [Super prove](https://github.com/sterin/super-prove-build) ABC-based AIGER hardware model checker (linux-x64 platform only)
 * [Pono](https://github.com/upscale-project/pono) an SMT-based model checker built on [smt-switch](https://github.com/makaimann/smt-switch)
 * [Z3](https://github.com/Z3Prover/z3) SMT solver
 * [Bitwuzla](https://github.com/bitwuzla/bitwuzla) SMT solver

### PnR (Place and Route)
 * [nextpnr](https://github.com/YosysHQ/nextpnr) a portable FPGA place and route tool (generic, ice40, ecp5, machxo2, nexus, gowin)
 * [Project IceStorm](https://github.com/YosysHQ/icestorm) tools for working with Lattice ICE40 bitstreams
 * [Project Trellis](https://github.com/YosysHQ/prjtrellis) tools for working with Lattice ECP5 bitstreams
 * [Project Oxide](https://github.com/gatecat/prjoxide) tools for working with Lattice Nexus bitstreams
 * [Project Apicula](https://github.com/YosysHQ/apicula) tools for working with Gowin bitstreams
 * [Project Peppercorn](https://github.com/YosysHQ/prjpeppercorn) tools for working with Cologne Chip GateMate bitstreams
 
### FPGA board programming tools
 * [openFPGALoader](https://github.com/trabucayre/openFPGALoader) universal utility for programming FPGA
 * [dfu-util](http://dfu-util.sourceforge.net/) Device Firmware Upgrade Utilities
 * [ecpprog](https://github.com/gregdavill/ecpprog) basic driver for FTDI based JTAG probes, to program ECP5 FPGAs
 * [ecpdap](https://github.com/adamgreig/ecpdap) program ECP5 FPGAs and attached SPI flash using CMSIS-DAP probes in JTAG mode
 * [fujprog](https://github.com/kost/fujprog) ULX2S / ULX3S JTAG programmer
 * [openocd](http://openocd.org/) Open On-Chip Debugger
 * [icesprog](https://github.com/wuxx/icesugar/tree/master/tools/src) iCESugar FPGA board programmer
 * [iceprogduino](https://github.com/OLIMEX/iCE40HX1K-EVB/tree/master/programmer/iceprogduino) Olinuxino based programmer for iCE40HX1K-EVB
 * [TinyFPGA](https://github.com/tinyfpga/TinyFPGA-Bootloader) USB Bootloader
 * [TinyFPGA-B](https://github.com/tinyfpga/TinyFPGA-B-Series) TinyFPGA B2 Board programmer
 * [iceFUN](https://github.com/pitrz/icefunprog) iceFUN Programmer
 
### Simulation/Testing
 * [GTK Wave](https://github.com/gtkwave/gtkwave) fully featured GTK+ based wave viewer
 * [verilator](https://github.com/verilator/verilator) Verilog/SystemVerilog simulator
 * [iverilog](https://github.com/steveicarus/iverilog) Verilog compilation system
 * [cocotb](https://github.com/cocotb/cocotb) coroutine based cosimulation library for writing VHDL and Verilog testbenches in Python
   
### Support libraries
 * [Python 3](https://github.com/python/cpython) language interpreter is provided in all supported platforms.
 * [Python 2](https://github.com/python/cpython) language interpreter is provided in Linux platforms in form of library only.
 * [Ubuntu 22.04](https://ubuntu.com/) distribution development packages are used and shared libraries used are provided in package.
 * [macports](https://www.macports.org/) distribution system for macOS is used to obtain all libraries used, and they are provided in package.
 * [MinGW](https://sourceforge.net/projects/mingw) Minimalist GNU for Windows library packages from Fedora 39 are used in compilation and provided in package.
 
## Installation

1. Download an archive matching your OS from [the releases page](https://github.com/YosysHQ/oss-cad-suite-build/releases/latest).
2. Extract the archive to a location of your choice (for Windows it is recommended that path does not contain spaces)
3. On macOS to allow execution of quarantined files ```xattr -d com.apple.quarantine oss-cad-suite-darwin-x64-yyymmdd.tgz``` on downloaded file, or run: ```./activate``` in extracted location once.
4. Set the environment as described below.

Linux and macOS
```bash
export PATH="<extracted_location>/oss-cad-suite/bin:$PATH"

# or

source <extracted_location>/oss-cad-suite/environment
```

Linux and macOS (fish shell)
```bash
fish_add_path "<extracted_location>/oss-cad-suite/bin"

# or

source <extracted_location>/oss-cad-suite/environment.fish
```

Windows
```batch
from existing CMD prompt:
<extracted_location>\oss-cad-suite\environment.bat

from existing PowerShell prompt:
. <extracted_location>\oss-cad-suite\environment.ps1

to create new CMD prompt:
<extracted_location>\oss-cad-suite\start.bat
```

**NOTE:** when environment is set, `python3` from package becomes available as well, this enables usage of *Migen* and *Amaranth* HDL and *LiteX* libraries scripts as usual. When OSS CAD Suite is just added in PATH to use packaged python3 use `tabbypy3` to start python environment. For Windows, there are no wrappers and using environment.bat is only choice.

## Using LiteX

We provide you with Python 3.11 and all required software to be able to use LiteX. After activating `environment` it is possible to perform installation same as usual:

```bash
mkdir -p litex
cd litex
wget https://raw.githubusercontent.com/enjoy-digital/litex/master/litex_setup.py
python3 litex_setup.py init
python3 litex_setup.py install
```

## Supported Architectures

### linux-x64
Any personal Linux based computer should just work; no additional packages need to be installed on the system to make OSS CAD Suite work.
Distributed libraries are based on Ubuntu 20.04, but everything is packaged in such a way so it can be used on any Linux distribution.

### darwin-x64
Any macOS 12.00 or later with Intel CPU should use this distribution package.

### darwin-arm64
Any macOS 12.00 or later with M1/M2 CPU should use this distribution package.

### windows-x64
This architecture is supported for Windows 10 and 11. 

### linux-arm64
ARM64 based Linux devices using 64bit CPU as in Raspberry Pi 4,5 and 400 (with 64bit version of OS installed), and also laptops like the MNT Reform 2 can use this distribution package.

## Contributing

To be able to build OSS CAD Suite yourself, you need to install `docker` (please note this only works on x64 platforms) and `python 3.6` or higher, with the `click` library.


After that just running ```./builder.py``` should work fine.

To build default build:
```bash
./builder.py build 
```

To skip update of source code, you can always:
```bash
./builder.py build --no-update
```

To build specific target and architecture:
```bash
./builder.py build --target=yosys --arch=linux-arm64
```

## Alternatives

If your project is primarily written in Python (using tools such as Amaranth or LiteX), and you only need synthesis and PnR tools, you might find [YoWASP](https://yowasp.org) more suited to your needs since it allows managing installation and versioning of these tools in the same way as any other Python package dependencies.
