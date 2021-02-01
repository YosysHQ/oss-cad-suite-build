cd ghdl
./configure --prefix=${INSTALL_PREFIX}
make DESTDIR=${OUTPUT_DIR} -j${NPROC}
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
