mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/bin
pushd libusb/examples
${CC} -o lsusb${EXE} listdevs.c -lusb-1.0 -I../libusb
${STRIP} lsusb${EXE}
cp lsusb${EXE} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/.
popd
pushd libftdi/examples
${CC} -o lsftdi${EXE} find_all.c -lftdi1 -lusb-1.0 -I../src
${STRIP} lsftdi${EXE}
cp lsftdi${EXE} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/.
popd
