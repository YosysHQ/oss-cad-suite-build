cd sby
make PREFIX=${INSTALL_PREFIX} DESTDIR=${OUTPUT_DIR} -j${NPROC} install
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/examples/sby
cp -r docs/examples/* ${OUTPUT_DIR}${INSTALL_PREFIX}/examples/sby/.
