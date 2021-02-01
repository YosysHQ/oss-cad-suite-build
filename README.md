# FPGA-Nightly

Steps for building

Install required python3 library

```
pip install click
```

After that just running ```./nightly.py``` should work fine.

To build default build:
```
./nightly.py build 
```

To skip update of source code you can always:
```
./nightly.py build --no-update
```

To build specific target:
```
./nightly.py build --target yosys
```
