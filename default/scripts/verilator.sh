if [ ${ARCH_BASE} == 'darwin' ]; then
    # Force usage of system flex/bison
    export PATH=/usr/bin:$PATH
fi
cd verilator
autoconf
./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME}
make DESTDIR=${OUTPUT_DIR} -j${NPROC}
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
