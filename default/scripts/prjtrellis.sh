cd prjtrellis
cd libtrellis
if [ ${ARCH_BASE} == 'windows' ]; then
    if [ ${IS_NATIVE} != 'True' ]; then
        sed -i 's/Windows.h/windows.h/g' tools/ecpbram.cpp
        sed -i 's,\${CMAKE_DL_LIBS}, ,g' CMakeLists.txt
    fi
fi
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
      -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} -DBUILD_PYTHON=OFF \
      .
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
if [ ${ARCH_BASE} == 'darwin' ]; then
    install_name_tool -id ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/trellis/libtrellis.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/trellis/libtrellis.dylib
    for binfile in $(file -h ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/* | grep Mach-O | grep executable | cut -f1 -d:); do
        install_name_tool -add_rpath ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/trellis $binfile
    done
fi
