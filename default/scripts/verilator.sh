if [ ${ARCH_BASE} == 'darwin' ]; then
    # Force usage of system flex/bison
    export PATH=/usr/bin:$PATH
fi
cd verilator
if [ ${ARCH_BASE} == 'windows' ]; then
    if [ ${IS_NATIVE} != 'True' ]; then
        sed -i 's,INSTALL_PROGRAM) verilator_bin \$(DESTDIR)\$(bindir)/verilator_bin,INSTALL_PROGRAM) verilator_bin.exe \$(DESTDIR)\$(bindir)/verilator_bin.exe,g' Makefile.in
        sed -i 's,INSTALL_PROGRAM) verilator_bin_dbg \$(DESTDIR)\$(bindir)/verilator_bin_dbg,INSTALL_PROGRAM) verilator_bin_dbg.exe \$(DESTDIR)\$(bindir)/verilator_bin_dbg.exe,g' Makefile.in
        sed -i 's,INSTALL_PROGRAM) verilator_coverage_bin_dbg \$(DESTDIR)\$(bindir)/verilator_coverage_bin_dbg,INSTALL_PROGRAM) verilator_coverage_bin_dbg.exe \$(DESTDIR)\$(bindir)/verilator_coverage_bin_dbg.exe,g' Makefile.in
        sed -i 's,cd bin ;,cd bin ; sync ;,g' Makefile.in
    fi
fi
autoconf
./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME}
make DESTDIR=${OUTPUT_DIR} -j${NPROC}
make DESTDIR=${OUTPUT_DIR} prefix=${INSTALL_PREFIX} -j${NPROC} install
