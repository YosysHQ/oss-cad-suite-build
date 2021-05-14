# OSS CAD Suite

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
