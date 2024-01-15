mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/bin

# libusb
cd ${BUILD_DIR}/libusb/examples
${CC} -o lsusb${EXE} listdevs.c -lusb-1.0 -I../libusb
${STRIP} lsusb${EXE}
cp lsusb${EXE} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/.

# libftdi
cd ${BUILD_DIR}/libftdi/examples
${CC} -o lsftdi${EXE} find_all.c -lftdi1 -lusb-1.0 -I../src
${STRIP} lsftdi${EXE}
cp lsftdi${EXE} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/.

# dfu-util
cd ${BUILD_DIR}/dfu-util
./autogen.sh
./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME}
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install

# ecpdap
cd ${BUILD_DIR}
export PKG_CONFIG_ALLOW_CROSS=YES
cargo install --no-track --path ecpdap --root ${OUTPUT_DIR}${INSTALL_PREFIX} --target=${CARGO_TARGET}

# ecpprog
cd ${BUILD_DIR}/ecpprog/ecpprog
if [ ${ARCH} == 'darwin-arm64' ]; then
make CC=${CXX} C_STD=c++98 PREFIX=${INSTALL_PREFIX} DESTDIR=${OUTPUT_DIR} install -j${NPROC}
else
make C_STD=gnu99 PREFIX=${INSTALL_PREFIX} DESTDIR=${OUTPUT_DIR} install -j${NPROC}
fi

# fujprog
cd ${BUILD_DIR}/fujprog
if [ ${ARCH} == 'windows-x64' ]; then
    cp -f ftd2xx-amd64.lib ftd2xx.lib
    export CMAKE_TOOLCHAIN_FILE=${PATCHES_DIR}/Toolchain-mingw64.cmake
fi
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} .
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install

# iceprogduino
cd ${BUILD_DIR}
if [ ${ARCH} == 'windows-x64' ]; then
	cd iceprogduino/windows/winiceprogduino
	sed -i 's,usleep,usleep2,g' main.c
	${CXX} main.c -o iceprogduino.exe
else
	cd iceprogduino/programmer/iceprogduino
	${CXX} iceprogduino.c -o iceprogduino
fi
cp iceprogduino${EXE} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/.

# icesprog
cd ${BUILD_DIR}/icesprog/tools/src
if [ ${ARCH} == 'windows-x64' ] || [ ${ARCH_BASE} == 'darwin' ]; then
      sed -i 's,HIDAPI = hidapi-hidraw,HIDAPI = hidapi,g' Makefile
fi
make
cp icesprog${EXE} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/.


# openocd
cd ${BUILD_DIR}/openocd
# Patches and recipe from Adam Jelinski :
# https://github.com/hdl/conda-prog/tree/master/tools/openocd
mv tcl/target/1986ве1т.cfg tcl/target/1986be1t.cfg
mv tcl/target/к1879xб1я.cfg tcl/target/k1879x61r.cfg
patch -p1 < ${PATCHES_DIR}/openocd.diff
if [ ${ARCH_BASE} == 'darwin' ]; then
  sed -i 's,glibtoolize,libtoolize,g' src/jtag/drivers/libjaylink/autogen.sh
fi
./bootstrap
mkdir -p build
cd build
../configure \
  --prefix=${INSTALL_PREFIX} \
  --host=${CROSS_NAME} \
  --enable-static \
  --disable-shared \
  --enable-usb-blaster-2 \
  --enable-usb_blaster_libftdi \
  --enable-jtag_vpi \
  --enable-remote-bitbang \
  CFLAGS="-Wno-error"

make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
