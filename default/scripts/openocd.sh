cd openocd

# Patches and recipe from Adam Jelinski :
# https://github.com/hdl/conda-prog/tree/master/tools/openocd
mv tcl/target/1986ве1т.cfg tcl/target/1986be1t.cfg
mv tcl/target/к1879xб1я.cfg tcl/target/k1879x61r.cfg

patch -p1 < ${PATCHES_DIR}/openocd.diff

if [ ${ARCH} == 'darwin-x64' ]; then
  sed -i 's,__attribute__((weak,; //__attribute__((weak,g' src/helper/command.c
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
