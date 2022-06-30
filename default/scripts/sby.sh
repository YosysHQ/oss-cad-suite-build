cd sby
make PREFIX=${INSTALL_PREFIX} DESTDIR=${OUTPUT_DIR} -j${NPROC} install
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/examples
cp -r docs/examples/* ${OUTPUT_DIR}${INSTALL_PREFIX}/examples/.
find ${OUTPUT_DIR}${INSTALL_PREFIX}/examples/ -name "Makefile" -type f -delete
find ${OUTPUT_DIR}${INSTALL_PREFIX}/examples/ -name ".gitignore" -type f -delete
