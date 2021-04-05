cd ghdl
param=--with-llvm-config="llvm-config"
sed -i 's,ghdl1-llvm,../bin/ghdl1-llvm,g' configure
if [ ${ARCH} == 'linux-arm' ] || [ ${ARCH} == 'linux-arm64' ] || [ ${ARCH} == 'linux-riscv64' ]; then
    sed -i 's,grt-all libs.vhdl.llvm all.vpi,grt-all all.vpi,g' Makefile.in
    sed -i 's,install.llvm.program install.vhdllib,install.llvm.program ,g' Makefile.in
    sed -i '130,133d' Makefile.in
    export GNATMAKE=${CROSS_NAME}-gnatmake
    param=--with-llvm-config='llvm-config'
    LDFLAGS=-L/usr/lib/${CROSS_NAME}
elif [ ${ARCH} == 'darwin-x64' ]; then
    export PATH="$PATH:/opt/gnat/bin"
    export GNAT_LARGS="-static-libgcc"
elif [ ${ARCH} == 'windows-x64' ]; then
    sed -i 's,grt-all libs.vhdl.llvm all.vpi,grt-all all.vpi,g' Makefile.in
    sed -i 's,install.llvm.program install.vhdllib,install.llvm.program ,g' Makefile.in
    sed -i '130,133d' Makefile.in
    export GNATMAKE=${CROSS_NAME}-gnatmake
    sed -i 's,$(LDFLAGS) `$(LLVM_LDFLAGS)`,`$(LLVM_LDFLAGS)` $(LDFLAGS),g' src/ortho/llvm6/Makefile 
    param=--with-llvm-config="/usr/x86_64-w64-mingw32/bin/llvm-config"
    LDFLAGS="-luuid -lole32 -lz -lssp"
fi
./configure --prefix=${INSTALL_PREFIX} \
        --enable-checks \
        --enable-libghdl \
        --enable-synth \
        ${param} LDFLAGS="${LDFLAGS}"
        
make DESTDIR=${OUTPUT_DIR} -j${NPROC}
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install

