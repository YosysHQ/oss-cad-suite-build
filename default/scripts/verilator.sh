cd verilator
if [ ${ARCH_BASE} == 'darwin' ]; then
    cp ${PATCHES_DIR}/verilated.mk.in include/.
fi
autoconf
./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME}
make DESTDIR=${OUTPUT_DIR} -j${NPROC}
make DESTDIR=${OUTPUT_DIR} prefix=${INSTALL_PREFIX} -j${NPROC} install

sed -i 's,AR = '${AR}',AR = ar,g' ${OUTPUT_DIR}${INSTALL_PREFIX}/share/verilator/include/verilated.mk
sed -i 's,CXX = '${CXX}',CXX = g++,g' ${OUTPUT_DIR}${INSTALL_PREFIX}/share/verilator/include/verilated.mk
sed -i 's,LINK = '${CXX}',LINK = g++,g' ${OUTPUT_DIR}${INSTALL_PREFIX}/share/verilator/include/verilated.mk
sed -i 's,PERL = /usr/bin/perl,PERL = perl,g' ${OUTPUT_DIR}${INSTALL_PREFIX}/share/verilator/include/verilated.mk
sed -i 's,PYTHON3 = /usr/bin/python3,PYTHON3 = python3,g' ${OUTPUT_DIR}${INSTALL_PREFIX}/share/verilator/include/verilated.mk

if [ ${ARCH_BASE} == 'darwin' ]; then
    # Support older compiler then we compiling on
    sed -i 's,-Wno-bool-operation,,g' ${OUTPUT_DIR}${INSTALL_PREFIX}/share/verilator/include/verilated.mk
    sed -i 's,-Wno-tautological-bitwise-compare,,g' ${OUTPUT_DIR}${INSTALL_PREFIX}/share/verilator/include/verilated.mk
fi

${STRIP} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/verilator_bin*
${STRIP} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/verilator_coverage_bin*
cp ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/*_bin* ${OUTPUT_DIR}${INSTALL_PREFIX}/share/verilator/bin/.
