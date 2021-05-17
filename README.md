# OSS CAD Suite

[![linux-x64](https://github.com/YosysHQ/oss-cad-suite-build/actions/workflows/linux-x64.yml/badge.svg)](https://github.com/YosysHQ/oss-cad-suite-build/releases/latest)
[![darwin-x64](https://github.com/YosysHQ/oss-cad-suite-build/actions/workflows/darwin-x64.yml/badge.svg)](https://github.com/YosysHQ/oss-cad-suite-build/releases/latest)
[![windows-x64](https://github.com/YosysHQ/oss-cad-suite-build/actions/workflows/windows-x64.yml/badge.svg)](https://github.com/YosysHQ/oss-cad-suite-build/releases/latest)
[![linux-arm](https://github.com/YosysHQ/oss-cad-suite-build/actions/workflows/linux-arm.yml/badge.svg)](https://github.com/YosysHQ/oss-cad-suite-build/releases/latest)
[![linux-arm64](https://github.com/YosysHQ/oss-cad-suite-build/actions/workflows/linux-arm64.yml/badge.svg)](https://github.com/YosysHQ/oss-cad-suite-build/releases/latest)
[![linux-riscv64](https://github.com/YosysHQ/oss-cad-suite-build/actions/workflows/linux-riscv64.yml/badge.svg)](https://github.com/YosysHQ/oss-cad-suite-build/releases/latest)

Steps for building

Install required python3 library

```
pip install click
```

After that just running ```./builder.py``` should work fine.

To build default build:
```
./builder.py build 
```

To skip update of source code you can always:
```
./builder.py build --no-update
```

To build specific target:
```
./builder.py build --target yosys
```
