cd iverilog
sh autoconf.sh
if [ ${ARCH} == 'windows-x64' ]; then
    sed -i 's,@EXEEXT@,.exe,g' vvp/Makefile.in
    sed -i 's,@EXEEXT@,.exe,g' ivlpp/Makefile.in
    sed -i 's,@EXEEXT@,.exe,g' vhdlpp/Makefile.in
    sed -i 's,@EXEEXT@,.exe,g' driver/Makefile.in
    sed -i 's,@EXEEXT@,.exe,g' Makefile.in
    sed -i 's,@EXEEXT@,.exe,g' driver-vpi/Makefile.in
fi
if [ ${ARCH_BASE} == 'darwin' ]; then
    export CFLAGS="-Wno-implicit-function-declaration"
fi
./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME}
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
sed -i -re 's|^flag:VVP_EXECUTABLE=.*$||g' ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/ivl/vvp.conf
sed -i -re 's|^flag:VVP_EXECUTABLE=.*$||g' ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/ivl/vvp-s.conf
