cd iverilog
sh autoconf.sh
./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME}
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/include
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/*.a
sed -i -re 's|^flag:VVP_EXECUTABLE=.*$||g' ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/ivl/vvp.conf
sed -i -re 's|^flag:VVP_EXECUTABLE=.*$||g' ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/ivl/vvp-s.conf
