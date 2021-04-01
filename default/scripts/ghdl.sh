cd ghdl
if [ ${ARCH_BASE} == 'darwin' ]; then
    export PATH="$PATH:/opt/gnat/bin"
    export GNAT_LARGS="-static-libgcc"
fi
./configure --prefix=${INSTALL_PREFIX}
make DESTDIR=${OUTPUT_DIR} -j${NPROC}
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/include
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libghdl*
