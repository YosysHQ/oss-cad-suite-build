cd iverilog
sh autoconf.sh
# remove "Add CPPFLAGS & LDFLAGS for building version.exe & draw_tt build targets"
# breaks cross compiling builds
# revert 964878382d3fa77285b73d4657be5bbf95a9aacd
sed -i 's,$(BUILDCC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS),$(BUILDCC) $(CFLAGS),g' Makefile.in
sed -i 's,$(BUILDCC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS),$(BUILDCC) $(CFLAGS),g' vvp/Makefile.in
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
./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME} --enable-libvvp
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
sed -i -re 's|^flag:VVP_EXECUTABLE=.*$||g' ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/ivl/vvp.conf
sed -i -re 's|^flag:VVP_EXECUTABLE=.*$||g' ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/ivl/vvp-s.conf
if [ ${ARCH_BASE} == 'darwin' ]; then
    sed -i 's,CC="'${CC}',CC="clang",g' ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/iverilog-vpi
    sed -i 's,CXX="'${CXX}'",CXX="clang++",g' ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/iverilog-vpi
    install_name_tool -id ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libvvp.1.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libvvp.1.dylib
    install_name_tool -change ${INSTALL_PREFIX}/lib/libvvp.1.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libvvp.1.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/vvp    
fi
