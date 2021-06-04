cd verilator
if [ ${ARCH_BASE} == 'windows' ]; then
    patch -p1 < ${PATCHES_DIR}/verilator.diff
fi
autoconf
./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME}
make DESTDIR=${OUTPUT_DIR} -j${NPROC}
make DESTDIR=${OUTPUT_DIR} prefix=${INSTALL_PREFIX} -j${NPROC} install

sed -i 's,CXX = '${CXX}',CXX = g++,g' ${OUTPUT_DIR}${INSTALL_PREFIX}/share/verilator/include/verilated.mk
sed -i 's,LINK = '${CXX}',LINK = g++,g' ${OUTPUT_DIR}${INSTALL_PREFIX}/share/verilator/include/verilated.mk

${STRIP} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/verilator_bin*
${STRIP} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/verilator_coverage_bin*
cp ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/*_bin* ${OUTPUT_DIR}${INSTALL_PREFIX}/share/verilator/bin/.
