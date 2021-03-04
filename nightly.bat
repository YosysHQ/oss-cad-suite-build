@echo off
@set CHERE_INVOKING=1
@set MSYSTEM=MINGW64
C:\msys64\usr\bin\bash -lc '/usr/bin/python3 nightly.py %*'