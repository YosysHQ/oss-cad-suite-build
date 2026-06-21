cd nvc
./autogen.sh
mkdir -p build
cd build
../configure --prefix=${INSTALL_PREFIX} --with-llvm=/usr/bin/llvm-config-18
make -j${NPROC}
make DESTDIR=${OUTPUT_DIR} install

# NVC installs vendor-library install helpers under libexec/nvc. They are located via an
# absolute compile-time path (not relocatable in the packaged suite) and their directory
# name collides with the packaging wrapper, which moves bin/nvc to libexec/nvc. Remove them
# so the nvc binary can be wrapped. The standard VHDL libraries (lib/nvc) are unaffected.
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec
