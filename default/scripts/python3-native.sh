cd python3
./configure --prefix=${INSTALL_PREFIX} -with-ensurepip=install
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
rm -f ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/*.a
