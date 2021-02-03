cd ghdl
if [ ${ARCH_BASE} == 'darwin' ]; then
    export PATH="$PATH:/opt/gnat/bin"
    export GNAT_LARGS="-static-libgcc"
fi
./configure --prefix=${INSTALL_PREFIX}
make DESTDIR=${OUTPUT_DIR} -j${NPROC}
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
