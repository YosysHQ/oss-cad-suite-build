cd mcy
sed -i -re "s,cmake,cmake -DCMAKE_TOOLCHAIN_FILE=\${CMAKE_TOOLCHAIN_FILE},g" Makefile
make PREFIX=${INSTALL_PREFIX} DESTDIR=${OUTPUT_DIR} -j${NPROC} build
make PREFIX=${INSTALL_PREFIX} DESTDIR=${OUTPUT_DIR} -j${NPROC} install
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/examples/mcy
cp -r examples/* ${OUTPUT_DIR}${INSTALL_PREFIX}/examples/mcy/.
